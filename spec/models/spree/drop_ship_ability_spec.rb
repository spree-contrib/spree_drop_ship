require 'spec_helper'
require 'cancan/matchers'

describe Spree::DropShipAbility do

  let(:user) { Factory(:user) }
  let(:ability) { subject.new(Factory(:user)) }

  pending 'Need to write spec.'

end
