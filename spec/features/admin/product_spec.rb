require 'spec_helper'

feature 'Admin - Product', js: true do

  context 'as Admin' do

    it 'should be able to change supplier' do
      s1 = create(:supplier)
      s2 = create(:supplier)
      product = create :product, supplier: s1

      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select s2.name, from: 'product[supplier_id]'
      click_button 'Update'

      page.should have_content("Product \"#{product.name}\" has been successfully updated!")
      product.reload.supplier_id.should eql(s2.id)
    end

  end

end
