require 'spec_helper'

describe Spree::Order do

  it { should have_many(:drop_ship_orders) }

  context '#finalize_with_drop_ship!' do

    after do
      SpreeDropShip::Config[:automatically_deliver_orders_to_supplier] = true
    end

    it 'should deliver drop ship orders when Spree::DropShipConfig[:automatically_deliver_orders_to_supplier] == true' do
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_supplier)), create(:line_item, variant: create(:variant_with_supplier))]

      deliver_count = 0
      Spree::DropShipOrder.any_instance.stub(:deliver!) do |arg|
        deliver_count+=1
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      deliver_count.should eql(2)
      order.drop_ship_orders.size.should eql(2)
      order.drop_ship_orders.each do |dso|
        dso.line_items.size.should eql(1)
        dso.line_items.first.product.supplier.should eql(dso.supplier)
      end
    end

    it 'should NOT deliver drop ship orders when Spree::DropShipConfig[:automatically_deliver_orders_to_supplier] == false' do
      SpreeDropShip::Config[:automatically_deliver_orders_to_supplier] = false
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_supplier)), create(:line_item, variant: create(:variant_with_supplier))]

      deliver_count = 0
      Spree::DropShipOrder.any_instance.stub(:deliver!) do |arg|
        deliver_count+=1
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      deliver_count.should eql(0)
      order.drop_ship_orders.size.should eql(2)
      order.drop_ship_orders.each do |dso|
        dso.line_items.size.should eql(1)
        dso.line_items.first.product.supplier.should eql(dso.supplier)
      end
    end

  end

end
