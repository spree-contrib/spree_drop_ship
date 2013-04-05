require 'spec_helper'

describe Spree::StockLocation do

  it { should belong_to(:supplier) }

end
