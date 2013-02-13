require 'spec_helper'

describe Spree.user_class do

  it { should have_one(:supplier) }

  let(:user) { build :user }

  it '#admin?' do
    #spree_roles.pluck(:name).include?('admin')
    pending 'should be moved and tested in spree_auth_devise'
  end

  it '#has_supplier?' do
    user.has_supplier?.should be_false
    user.supplier = build :supplier
    user.has_supplier?.should be_true
  end

end
