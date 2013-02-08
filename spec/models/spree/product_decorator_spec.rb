require 'spec_helper'

describe Spree::Product do

  it { should have_one(:supplier).through(:supplier_product) }
  it { should have_one(:supplier_product).dependent(:destroy) }

  let(:product) { build :product }

  it '#has_supplier?' do
    product.has_supplier?.should be_false
    product.supplier = build :supplier
    product.has_supplier?.should be_true
  end

end
