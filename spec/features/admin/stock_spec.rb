require 'spec_helper'

feature 'Admin - Products', js: true do

  before do
    @user = create(:supplier_user)
    @supplier1 = @user.supplier
    @supplier2 = create(:supplier)
    @product = create :product, supplier: @supplier1
  end

  context 'as Admin' do

    scenario 'should display all stock locations' do
      login_user create(:admin_user)
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        page.should have_content(@supplier1.name)
        page.should have_content(@supplier2.name)
      end
    end

  end

  context 'as Supplier' do

    scenario 'should only display suppliers stock locations' do
      login_user @user
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        page.should have_content(@supplier1.name)
        page.should_not have_content(@supplier2.name)
      end
    end

  end

end
