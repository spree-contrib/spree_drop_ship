require 'spec_helper'

describe Spree::DropShipOrder do

  it { should belong_to(:order) }
  it { should belong_to(:supplier) }

  it { should have_many(:drop_ship_line_items).dependent(:destroy) }
  it { should have_many(:line_items).through(:drop_ship_line_items) }
  it { should have_many(:return_authorizations).through(:order) }
  it { should have_many(:stock_locations).through(:supplier) }
  it { should have_many(:users).through(:supplier) }

  it { should have_one(:user) }

  it { should validate_presence_of(:commission) }
  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:supplier_id) }

  it '#currency' do
    record = create(:drop_ship_order)
    record.currency.should eql(record.order.currency)
  end

  it '#destroy' do
    instance = create(:drop_ship_order)
    instance.destroy.should eql(false)
  end

  it '#display_tax_total' do
    dso = build(:drop_ship_order)
    dso.stub tax_total: 6.0
    dso.display_tax_total.should == Spree::Money.new(6.0)
  end

  it '#display_total' do
    record = create(:order_for_drop_ship).drop_ship_orders.first
    record.display_total.should == Spree::Money.new(50.0)
  end

  it '#item_total' do
    line_items = [stub(:amount => 10), stub(:amount => 20)]
    subject.stub :line_items => line_items
    subject.item_total.should eql(30)
  end

  it '#number' do
    record = create(:drop_ship_order)
    record.number.should eql(record.id)
  end

  it '#payment_state' do
    record = create(:drop_ship_order)
    record.payment_state.should eql(record.order.payment_state)
  end

  it '#promo_total' do
    dso = create(:drop_ship_order)
    dso.order.adjustments = [create(:adjustment, adjustable: dso.order, amount: -5, originator_type: 'Spree::PromotionAction'), create(:adjustment, adjustable: dso.order, amount: 5, originator_type: 'Spree::ShippingMethod'), create(:adjustment, adjustable: dso.order, amount: 6, adjustable_type: 'Spree::Order', originator_type: 'Spree::TaxRate')]
    dso.reload.promo_total.to_f.should eql(-5.0)
  end

  it '#ship_address' do
    record = create(:drop_ship_order)
    record.ship_address.should eql(record.order.ship_address)
  end

  it '#ship_total' do
    supplier = create(:supplier)
    dso = create(:drop_ship_order, supplier: supplier)
    stock_location = create(:stock_location, supplier: supplier)
    order = create(:order)
    shipment1 = create(:shipment, order: order, stock_location: stock_location)
    shipment2 = create(:shipment, order: order)
    order.adjustments = [
      create(:adjustment, adjustable: order, amount: -5, originator_type: 'Spree::PromotionAction'),
      create(:adjustment, adjustable: order, amount: 4, originator_type: 'Spree::ShippingMethod', source: shipment1),
      create(:adjustment, adjustable: order, amount: 5, originator_type: 'Spree::ShippingMethod', source: shipment2),
      create(:adjustment, adjustable: order, amount: 6, adjustable_type: 'Spree::Order', originator_type: 'Spree::TaxRate')
    ]
    dso.order = order.reload
    dso.ship_total.to_f.should eql(4.0)
  end

  it '#shipment_state' do
    dso = stub_model(Spree::DropShipOrder)
    dso.stub_chain(:shipments, :size).and_return(0)
    dso.shipment_state.should eql('pending')

    dso.stub_chain(:shipments, :size).and_return(1)
    dso.stub_chain(:shipments, :pending, :size).and_return(1)
    dso.shipment_state.should eql('pending')

    dso.stub_chain(:shipments, :pending, :size).and_return(0)
    dso.stub_chain(:shipments, :ready, :size).and_return(1)
    dso.shipment_state.should eql('ready')

    dso.stub_chain(:shipments, :ready, :size).and_return(0)
    dso.stub_chain(:shipments, :shipped, :size).and_return(1)
    dso.shipment_state.should eql('shipped')

    dso.stub_chain(:shipments, :size).and_return(2)
    dso.stub_chain(:shipments, :ready, :size).and_return(1)
    dso.shipment_state.should eql('partial')
  end

  it '#shipments' do
    supplier = create(:supplier)
    dso = create(:drop_ship_order, supplier: supplier)
    stock_location = create(:stock_location, supplier: supplier)
    order = create(:order)
    shipment1 = create(:shipment, order: order, stock_location: stock_location)
    shipment2 = create(:shipment, order: order)
    dso.order = order.reload
    dso.shipments.to_a.should eql([shipment1])
  end

  it '#tax_total' do
    dso = create(:drop_ship_order)
    dso.order.adjustments = [create(:adjustment, adjustable: dso.order, amount: -5, originator_type: 'Spree::PromotionAction'), create(:adjustment, adjustable: dso.order, amount: 5, originator_type: 'Spree::ShippingMethod'), create(:adjustment, adjustable: dso.order, amount: 6, adjustable_type: 'Spree::Order', originator_type: 'Spree::TaxRate')]
    dso.tax_total.to_f.should eql(6.0)
  end

  it '#total' do
    record = create(:order_for_drop_ship).drop_ship_orders.first
    record.total.to_f.should eql(50.0)
  end

  it '#update_commission' do
    record = create(:drop_ship_order)
    record.supplier.stub commission_flat_rate: 0.3
    record.supplier.stub commission_percentage: 10
    record.stub total: 110
    record.save
    record.reload.commission.to_f.should eql(11.3)
  end

  context "A new drop ship order" do

    it "should calcluate total when empty" do
      @drop_ship_order = build(:drop_ship_order)
      assert_equal 0.0, @drop_ship_order.send(:update_total)
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

      context 'with DropShopConfig[:send_supplier_email] == false' do
        after do
          SpreeDropShip::Config.set send_supplier_email: true
          ActionMailer::Base.deliveries = []
        end
        before do
          SpreeDropShip::Config.set send_supplier_email: false
          ActionMailer::Base.deliveries = []
          @drop_ship_order.deliver!
        end
        it 'should not deliver mail' do
          ActionMailer::Base.deliveries.size.should eql(0)
        end
      end

      context 'with DropShopConfig[:send_supplier_email] == true (default)' do

        before do
          @drop_ship_order.deliver!
        end

        it "should move to the 'delivered' state" do
          assert_equal 'delivered', @drop_ship_order.state
        end

        it "should set sent at" do
          assert_not_nil @drop_ship_order.sent_at
        end

        it "should send order to supplier" do
          assert_equal @drop_ship_order.supplier.email, ActionMailer::Base.deliveries.last.to.first
          assert_equal "#{Spree::Config[:site_name]} Drop Ship Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries.last.subject
        end

      end

      context "and confirmed" do

        before do
          @drop_ship_order.deliver!
          @drop_ship_order.confirm!
        end

        it "should move to the 'confirmed' state" do
          assert_equal "confirmed", @drop_ship_order.state
        end

        it "should set confirmed at" do
          assert_not_nil @drop_ship_order.confirmed_at
        end

        context "and completed" do

          before do
            @drop_ship_order.complete!
          end

          it "should move to the 'complete' state" do
            assert_equal "completed", @drop_ship_order.state
          end

          it "should set completed at" do
            assert_not_nil @drop_ship_order.completed_at
          end

        end

      end

    end

  end

end
