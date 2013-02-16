require 'spec_helper'

describe Spree::Product do

  it { should belong_to(:supplier) }

  let(:product) { build :product }

  it '#has_supplier?' do
    product.has_supplier?.should be_false
    product.supplier = build :supplier
    product.has_supplier?.should be_true
  end

end
