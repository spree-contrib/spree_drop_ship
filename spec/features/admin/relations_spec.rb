require 'spec_helper'

feature 'Admin - Product Relation Management', js: true do

  before do
    Spree::RelationType.create(:name => "Related Products", :applies_to => "Spree::Product")
    @user = create(:supplier_user)
    @supplier1 = @user.supplier
    @supplier2 = create(:supplier)
    @product1 = create :product, supplier: @supplier1
    # TODO shoudl we allow them to relate to anyones product or only their own?
    @product2 = create :product
  end

  context 'as Supplier' do
    scenario 'should be able to add relations' do
      login_user @user
      visit spree.related_admin_product_path(@product1)
      targetted_select2_search @product2.name, from: 'Name or SKU'
      select2 @product2.name, from: 'Name or SKU'
      click_link 'Add'
      within '#products-table-wrapper' do
        page.should have_content(@product2.name)
      end
    end
  end

end
