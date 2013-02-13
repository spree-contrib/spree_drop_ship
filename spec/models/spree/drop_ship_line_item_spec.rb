require 'spec_helper'

describe Spree::DropShipLineItem do

  it { should belong_to(:line_item) }
  it { should belong_to(:drop_ship_order) }

  it { should validate_presence_of(:drop_ship_order_id) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:variant_id) }

  it '#subtotal' do
    item = Spree::DropShipLineItem.new quantity: 5, price: 1
    item.subtotal.should eql(5.0)
  end

end
