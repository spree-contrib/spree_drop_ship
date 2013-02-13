require 'spec_helper'

describe Spree::SupplierProduct do

  it { should belong_to(:product) }
  it { should belong_to(:supplier) }

  it { should validate_presence_of(:product_id) }
  it { should validate_presence_of(:supplier_id) }

end
