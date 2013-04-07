require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::SupplierAbility do

  let(:user) { create(:user, supplier: create(:supplier)) }
  let(:ability) { Spree::SupplierAbility.new(user) }
  let(:token) { nil }

  context 'for DropShipOrder' do
    let(:resource) { Spree::DropShipOrder.new }

    context 'requested by any user' do
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      it 'should be able to administer updates' do
        resource.supplier = user.supplier
        ability.should be_able_to :admin, resource
        ability.should_not be_able_to :create, resource
        ability.should_not be_able_to :destroy, resource
        ability.should be_able_to :read, resource
        ability.should be_able_to :update, resource
      end
    end
  end

  context 'for Product' do
    context 'requested by another suppliers user' do
      let(:resource) { Spree::Product.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::Product.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Shipment' do
    context 'requested by another suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: create(:supplier))}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: user.supplier)}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requested by any user' do
      let(:resource) { Spree::StockLocation.new }
      it_should_behave_like 'access denied'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:resource) { Spree::Supplier.new }

      context 'w/ DropShipConfig[:allow_signup] == false (the default)' do
        it_should_behave_like 'access denied'
      end

      context 'w/ DropShipConfig[:allow_signup] == true' do
        after do
          Spree::DropShipConfig[:allow_signup] = false
        end
        before do
          Spree::DropShipConfig[:allow_signup] = true
        end
        it_should_behave_like 'create only'
      end
    end

    context 'requested by suppliers user' do
      let(:resource) { user.supplier }
      it_should_behave_like 'access granted'
    end
  end

end
