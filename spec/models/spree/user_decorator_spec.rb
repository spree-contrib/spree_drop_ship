require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:supplier) }

  it { should have_many(:variants).through(:supplier) }

  let(:user) { build :user }

  it '#supplier?' do
    user.supplier?.should be_false
    user.supplier = build :supplier
    user.supplier?.should be_true
  end

end
