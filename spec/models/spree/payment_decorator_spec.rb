require 'spec_helper'

describe Spree::Payment do

  it { should belong_to(:shipment) }

  context '#gateway_options' do
    it 'should return drop ship totals when belonging to drop ship order' do
      pending
    end

    it 'should return order totals when NOT belonging to drop ship order' do
      pending
    end
  end

end
