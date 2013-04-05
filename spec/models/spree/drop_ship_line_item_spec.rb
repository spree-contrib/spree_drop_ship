require 'spec_helper'

describe Spree::DropShipLineItem do

  it { should belong_to(:line_item) }
  it { should belong_to(:drop_ship_order) }

end
