require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    xit 'should be able to change supplier' do
      s1 = create(:supplier)
      s2 = create(:supplier)
      product = create :product
      product.add_supplier! s1

      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select2 s2.name, from: 'Supplier'
      click_button 'Update'

      expect(page).to have_content("Product \"#{product.name}\" has been successfully updated!")
      expect(product.reload.suppliers.first.id).to eql(s2.id)
    end

  end

end
