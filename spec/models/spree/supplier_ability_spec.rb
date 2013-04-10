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
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end

    context 'requested by suppliers user' do
      before do
        resource.supplier = user.supplier
      end

      it_should_behave_like 'index allowed'
      it_should_behave_like 'admin granted'

      it 'should be able to administer updates' do
        ability.should be_able_to :admin, resource
        ability.should_not be_able_to :create, resource
        ability.should_not be_able_to :destroy, resource
        ability.should be_able_to :read, resource
        ability.should be_able_to :update, resource
      end
    end
  end

  context 'for Product' do
    let(:resource) { Spree::Product }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

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
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: user.supplier)}, without_protection: true) }
      it_should_behave_like 'access granted'
      it_should_behave_like 'index allowed'
      it_should_behave_like 'admin granted'
    end
  end

  context 'for StockLocation' do
    context 'requested by any user' do
      let(:resource) { Spree::StockLocation.new }
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end

    context 'requsted by another suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
      it_should_behave_like 'index allowed'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:resource) { Spree::Supplier.new }

      it_should_behave_like 'admin denied'

      context 'w/ DropShipConfig[:allow_signup] == false (the default)' do
        it_should_behave_like 'access denied'
      end

      context 'w/ DropShipConfig[:allow_signup] == true' do
        after do
          Spree::DropShipConfig.set allow_signup: false
        end
        before do
          Spree::DropShipConfig.set allow_signup: true
        end
        it 'should be able to create' do
          ability.should_not be_able_to :admin, resource
          ability.should be_able_to :create, resource
          ability.should_not be_able_to :destroy, resource
          ability.should_not be_able_to :read, resource
          ability.should_not be_able_to :update, resource
        end
      end
    end

    context 'requested by suppliers user' do
      let(:resource) { user.supplier }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
    end
  end

end
