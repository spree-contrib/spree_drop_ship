require 'spec_helper'

describe Spree::Order do

  it { should have_many(:drop_ship_orders) }

  it '#approve_drop_ship_orders' do
    order = create(:order_with_totals, bill_address: create(:address), ship_address: create(:address))
    order.line_items = [create(:line_item_to_drop_ship), create(:line_item_to_drop_ship)]
    order.finalize!

    order.approve_drop_ship_orders.should be_true
  end

  it '#finalize_with_dropship!' do
   order = create(:order_with_totals)
   order.line_items = [create(:line_item_to_drop_ship), create(:line_item_to_drop_ship)]

   order.finalize!

   order.drop_ship_orders.size.should eql(2)
  end

  it '#has_drop_ship_orders?' do
    order = create(:order)
    order.has_drop_ship_orders?.should eql(false)
    order = create(:drop_ship_order).order
    order.has_drop_ship_orders?.should eql(true)
  end

end
