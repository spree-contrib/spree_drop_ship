require 'spec_helper'

describe Spree::Order do

  it { should have_many(:drop_ship_orders) }

  it '#approve_drop_ship_orders' do
    #drop_ship_orders.select{ |dso| dso.deliver }.length == drop_ship_orders.length
    pending
  end

  it '#finalize_with_dropship!' do
    subject.respond_to?(:finalize_with_dropship!).should be_true

    #finalize_without_dropship!

#    self.line_items.will_drop_ship.all.group_by{|li| li.supplier_id }.each do |supplier_id, supplier_items|
 #     supplier = Spree::Supplier.find(supplier_id)
  #    supplier.orders.create(:order => self).add(supplier_items) #.deliver!
   # end
   pending
  end

  it '#has_drop_ship_orders?' do
    order = create(:order)
    order.has_drop_ship_orders?.should eql(false)
    order = create(:drop_ship_order).order
    order.has_drop_ship_orders?.should eql(true)
  end

end
