require 'spec_helper'

describe Spree::Product do

  it { should belong_to(:supplier) }

  let(:product) { build :product }

  it '#supplier?' do
    product.supplier?.should be false
    product.supplier = build :supplier
    product.supplier?.should be true
  end

end
