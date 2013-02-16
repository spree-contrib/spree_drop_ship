require 'spec_helper'

describe 'Drop Ship Orders', js: true do

  context 'without access' do
    before do
      # TODO: why do users get granted admin role access on login???
      @user = create(:supplier_user)
      login_user @user
      @user.spree_roles.destroy_all
      @order = create(:drop_ship_order, supplier: create(:supplier, user: create(:user)))
    end
    it 'should redirect on another users orders' do
      visit spree.drop_ship_order_path(@order)
      page.should have_content('Unauthorized')
    end
  end

  context 'as Supplier' do

    before do
      @user = create(:supplier).user
      @order = create(:drop_ship_order)
      @order.deliver
      login_user @user
    end

    it 'edit - should properly display and allow confirmation' do
      visit spree.edit_drop_ship_order_path(@order)
      page.should have_content(@order.id)

      click_button 'Confirm Order'
      page.should have_content("We've been notified that you've confirmed this order. To complete the order please, upon shipping, enter the shipping information and click 'Process and finalize order'.")
    end

    it 'confirm - should properly fire for initial send and resend' do
      visit spree.edit_drop_ship_order_path(@order)
      page.should have_content(@order.id)

      click_button 'Confirm Order'
      page.should have_content("We've been notified that you've confirmed this order. To complete the order please, upon shipping, enter the shipping information and click 'Process and finalize order'.")

      # select 'USPS', from: 'drop_ship_order[shipping_method_id]'
      fill_in 'drop_ship_order[shipping_method]', with: 'USPS'
      fill_in 'drop_ship_order[tracking_number]', with: 'TEST'
      fill_in 'drop_ship_order[notes]', with: 'Test note.'

      click_button 'Process and finalize order'
      page.should have_content('Thank you for your shipment!')
    end

  end

end
