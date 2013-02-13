require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    it 'should display all products' do
      product1 = create :product
      product2 = create :product
      product2.supplier = create(:supplier)
      product2.save
      product3 = create :product
      product3.supplier = create(:supplier)
      product3.save

      login_user create(:admin_user)
      visit spree.admin_products_path

      page.should have_content(product1.name)
      page.should have_content(product2.name)
      page.should have_content(product3.name)
    end

  end

  context 'as Supplier' do

    it 'should only display the suppliers products' do
      supplier = create(:supplier)
      product1 = create(:product)
      product2 = create(:product)
      product2.supplier = supplier
      product2.save
      product3 = create(:product)

      # TODO Not sure why supplier being assigned user association gets the admin role to begin with... This is a quick workaround.
      Spree::Admin::ProductsController.any_instance.stub(:spree_current_user).and_return(supplier.user.reload)
      Spree::Admin::ProductsController.any_instance.stub_chain(:spree_current_user, :admin?).and_return(false)

      login_user supplier.user
      visit spree.admin_products_path

      page.should_not have_content(product1.name)
      page.should have_content(product2.name)
      page.should_not have_content(product3.name)
    end

  end

end
