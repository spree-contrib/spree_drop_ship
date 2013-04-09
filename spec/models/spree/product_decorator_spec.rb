require 'spec_helper'

describe Spree::Product do

  it { should belong_to(:supplier) }

  let(:product) { build :product }

  it '#supplier?' do
    product.supplier?.should be_false
    product.supplier = build :supplier
    product.supplier?.should be_true
  end

end
