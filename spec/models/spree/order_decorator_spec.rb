require 'spec_helper'

describe Spree::Order do

  it { should have_many(:drop_ship_orders) }

  it '#finalize_with_dropship!' do
   order = create(:order_with_totals, ship_address: create(:address))
   order.line_items = [create(:line_item, variant: create(:variant_with_supplier)), create(:line_item, variant: create(:variant_with_supplier))]

   order.finalize!

   order.drop_ship_orders.size.should eql(2)
   order.drop_ship_orders.each do |dso|
     dso.line_items.size.should eql(1)
     dso.line_items.first.product.supplier.should eql(dso.supplier)
   end
  end

end
