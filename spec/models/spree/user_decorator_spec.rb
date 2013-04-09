require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:supplier) }

  let(:user) { build :user }

  it '#admin?' do
    #spree_roles.pluck(:name).include?('admin')
    pending 'should be moved and tested in spree_auth_devise'
  end

  it '#supplier?' do
    user.supplier?.should be_false
    user.supplier = build :supplier
    user.supplier?.should be_true
  end

end
