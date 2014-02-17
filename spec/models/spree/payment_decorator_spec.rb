require 'spec_helper'

describe Spree::Payment do

  it { should belong_to(:payable) }

end
