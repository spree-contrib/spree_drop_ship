require 'spec_helper'

describe Spree::LineItem do

  it { should belong_to(:supplier) }

  it { should have_one(:drop_ship_line_item) }

  it '.will_drop_ship' do
    item1 = create(:line_item)
    item2 = create(:line_item, supplier_id: 1)
    item3 = create(:line_item)
    subject.class.will_drop_ship.to_a.should eql([item2])
  end

  it '#drop_ship_attributes' do
    pending 'TODO fix master price issue'
    supplier = create(:supplier)
    variant = create(:variant, sku: 'TEST')
    product = build(:product, name: 'Test Dropship Product', supplier: supplier)
    product.master = variant
    product.save
    item = create(:line_item, quantity: 2, variant: variant)
    item.drop_ship_attributes.should eql({
      :line_item_id => item.id,
      :name         => 'Test Dropship Product',
      :price        => 10,
      :quantity     => 2,
      :sku          => 'TEST',
      :variant_id   => variant.id
    })
  end

  it '#has_supplier?' do
    subject.has_supplier?.should be_false
    subject.supplier_id = 1
    subject.has_supplier?.should be_true
  end

  it '#set_supplier_id' do
    pending 'TODO fix master price issue'
    supplier = create(:supplier)
    product = create(:product, supplier: supplier)
    item = create(:line_item, variant: create(:variant, is_master: true, product: product))
    item.supplier_id.should be_nil
    item.valid?
    item.supplier_id.should eql(supplier.id)
  end

end
