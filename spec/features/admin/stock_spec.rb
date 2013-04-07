require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    it 'should display all stock locations' do
      product = create :product

      login_user create(:admin_user)
      visit spree.admin_product_stock_path(product)

      page.should have_content(product.name)
      pending 'finish writing'
    end

  end

  context 'as Supplier' do

    before do
      @supplier_user = create(:supplier_user)
      @supplier = @supplier_user.supplier
      login_user @supplier_user
    end

    it 'should only display suppliers stock locations' do
      product = create :product

      visit spree.admin_product_stock_path(product)

      page.should have_content(product.name)
      pending 'finish writing'
    end

  end

end
