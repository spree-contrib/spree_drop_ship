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
    supplier = create(:supplier)
    product = build(:product, name: 'Test Dropship Product')
    product.supplier = create(:supplier)
    product.save
    variant = create(:variant, product: product, sku: 'TEST')
    item = create(:line_item, quantity: 2, variant: variant)
    item.drop_ship_attributes.should eql({
      :line_item_id => item.id,
      :name         => 'Test Dropship Product',
      :price        => BigDecimal.new(10),
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
    supplier = create :supplier
    product  = create :product
    product.supplier = supplier
    product.save
    item = build(:line_item, variant: create(:variant, product: product))
    item.valid?
    item.supplier.id.should eql(supplier.id)
  end

end
