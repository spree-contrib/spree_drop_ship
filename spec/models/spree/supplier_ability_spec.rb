require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::SupplierAbility do

  let(:user) {
    user = create(:user)
    create(:supplier, users: [user])
    user
  }
  # Since we register Spree::SupplierAbility to Spree::Ability we test against it.
  let(:ability) { Spree::Ability.new(user) }
  let(:token) { nil }

  context 'for DropShipOrder' do
    let(:resource) { Spree::DropShipOrder.new }

    context 'requested by any user' do
      it_should_behave_like 'access denied'
    end

    context 'requsted by another suppliers user' do
      before(:each) { resource.supplier = create(:supplier) }
      it_should_behave_like 'access denied'
    end

    context 'requsted by suppliers user' do
      before(:each) { resource.supplier = user.supplier }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Product' do
    context 'requested by any user' do
      let(:resource) { Spree::Product.new }
      it_should_behave_like 'read only'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::Product.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requsted by suppliers user' do
      let(:resource) { Spree::Product.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Shipment' do
    context 'requested by any user' do
      let(:resource) { Spree::Shipment.new }
      it_should_behave_like 'read only'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: create(:supplier))}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requsted by suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: user.supplier)}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requested by any user' do
      let(:resource) { Spree::StockLocation.new }
      it_should_behave_like 'read only'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requsted by suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:resource) { Spree::Supplier.new }
      it_should_behave_like 'create only'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::Supplier.new({users: []}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requsted by suppliers user' do
      let(:resource) { Spree::Supplier.new({users: [user]}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

end
