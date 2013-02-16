require 'spec_helper'

describe Spree::DropShipOrder do

  it { should belong_to(:order) }
  it { should belong_to(:supplier) }

  it { should have_many(:line_items) }

  it { should have_one(:user).through(:supplier) }

  it { should validate_presence_of(:commission_fee) }
  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:supplier_id) }

  it '#destroy' do
    instance = create(:drop_ship_order)
    instance.destroy.should eql(false)
  end

  context "A new drop ship order" do

    it "should calcluate total when empty" do
      @drop_ship_order = build(:drop_ship_order)
      assert_equal 0.0, @drop_ship_order.update_total
    end

  end

  context "A suppliers active drop ship order" do

    before do
      @supplier = create(:supplier)
      @drop_ship_order = create(:drop_ship_order, supplier: @supplier)
      @supplier.orders << @drop_ship_order
    end

    it "should add line relevant line items" do
      suppliers_item = create(:line_item_to_drop_ship, supplier: @supplier)
      @line_items = [ create(:line_item), create(:line_item_to_drop_ship), suppliers_item ]
      @drop_ship_order.add(@line_items)
      assert_equal 1, @drop_ship_order.line_items.count
      assert_equal suppliers_item.attributes, @drop_ship_order.line_items.first.line_item.attributes
    end

    it "should update quantity of items already in order" do
      @line_item = create(:line_item_to_drop_ship, supplier: @supplier)
      @drop_ship_order.add(@line_item)
      assert_equal 1, @drop_ship_order.line_items.count
      assert_equal 1, @drop_ship_order.line_items.first.quantity

      @line_item.quantity = 3
      @drop_ship_order.add(@line_item)
      assert_equal 1, @drop_ship_order.line_items.count
      assert_equal 3, @drop_ship_order.line_items.first.quantity
    end

    it "should add items and update total" do
      @line_items = [ create(:line_item_to_drop_ship, supplier: @supplier), create(:line_item_to_drop_ship, supplier: @supplier), create(:line_item_to_drop_ship, supplier: @supplier) ]
      price = @line_items.map{|li| li.quantity * li.price }.inject(:+)
      @drop_ship_order.add(@line_items)
      assert_equal price.to_f, @drop_ship_order.total.to_f
    end

  end

  context "A drop ship order's state machine" do

    before do
      ActionMailer::Base.deliveries = []
      @drop_ship_order = create(:drop_ship_order)
      @drop_ship_order.order.ship_address = create(:address)
      @drop_ship_order.save
    end

    it "should start in the 'active' state" do
      assert_equal "active", @drop_ship_order.state
    end

    context "when delivered" do

      before do
        puts @drop_ship_order.inspect
        @drop_ship_order.deliver!
      end

      it "should move to the 'sent' state" do
        assert_equal "sent", @drop_ship_order.state
      end

      it "should set sent at" do
        assert_not_nil @drop_ship_order.sent_at
      end

      it "should send order to supplier" do
        assert_equal @drop_ship_order.supplier.email, ActionMailer::Base.deliveries.last.to.first
        assert_equal "#{Spree::Config[:site_name]} - Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries.last.subject
      end

      context "and confirmed" do

        before do
          @drop_ship_order.confirm!
        end

        it "should move to the 'confirmed' state" do
          assert_equal "confirmed", @drop_ship_order.state
        end

        it "should set confirmed at" do
          assert_not_nil @drop_ship_order.confirmed_at
        end

        it "should send confirmation to supplier" do
          assert_equal @drop_ship_order.supplier.email, ActionMailer::Base.deliveries.last.to.first
          assert_equal "Confirmation - #{Spree::Config[:site_name]} - Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries.last.subject
        end

        context "and shipped" do

          before do
            @drop_ship_order.update_attributes(
              {
                :shipping_method => "UPS Ground",
                :confirmation_number => "935468423",
                :tracking_number => "1Z03294230492345234"
              },
              :without_protection => true
            )
            @drop_ship_order.ship!
          end

          it "should move to the 'complete' state" do
            assert_equal "complete", @drop_ship_order.state
          end

          it "should set shipped at" do
            assert_not_nil @drop_ship_order.shipped_at
          end

          it "should send shipment email to supplier" do
            # the ship state sends two emails.. so we'll get the second to last here
            index = ActionMailer::Base.deliveries.length - 2
            assert_equal @drop_ship_order.supplier.email, ActionMailer::Base.deliveries[index].to.first
            assert_equal "Shipped - #{Spree::Config[:site_name]} - Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries[index].subject
          end

          it "should send shipment email to customer" do
            assert_equal @drop_ship_order.order.email, ActionMailer::Base.deliveries.last.to.first
            assert_equal "Shipped - #{Spree::Config[:site_name]} - Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries.last.subject
          end

        end

      end

    end

  end

end
