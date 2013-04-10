require 'spec_helper'

describe 'Admin - Drop Ship Orders', js: true do

  before do
    @order1 = create(:drop_ship_order)
    @order2 = create(:drop_ship_order)
    @order3 = create(:drop_ship_order)
  end

  context 'as Admin' do

    before do
      login_user create(:admin_user)
    end

    it 'index - should display all drop ship orders' do
      visit spree.admin_drop_ship_orders_path

      page.should have_content(@order1.id)
      page.should have_content(@order2.id)
      page.should have_content(@order3.id)
    end

    it 'show - should render properly' do
      visit spree.admin_drop_ship_order_path(@order1)
      page.should have_content(@order1.id)
    end

    it 'deliver - should properly fire for initial send and resend' do
      visit spree.admin_drop_ship_order_path(@order1)
      page.should have_content(@order1.id)

      click_link 'Send Order to Supplier'
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order1.id))

      click_link 'Resend Order to Supplier'
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order1.id))
    end

  end

  context 'as Supplier' do

    before do
      @supplier = @order2.supplier
      login_user @supplier
    end

    it 'should only display the suppliers orders' do
      visit spree.admin_drop_ship_orders_path

      page.should_not have_content(@order1.id)
      page.should have_content(@order2.id)
      page.should_not have_content(@order3.id)
    end

    it 'should render unauthorized visiting another suppliers order' do
      visit spree.admin_drop_ship_order_path(@order1)
      page.should have_content('Unauthorized')
    end

    it 'should render suppliers orders' do
      visit spree.admin_drop_ship_order_path(@order2)
      page.should have_content(@order2.id)
    end

    it 'should properly fire for initial send and resend' do
      visit spree.admin_drop_ship_order_path(@order2)
      page.should have_content(@order2.id)

      click_link 'Send Order to Supplier'
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order2.id))

      click_link 'Resend Order to Supplier'
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order2.id))
    end

    it 'edit - should properly display and allow confirmation' do
      visit spree.admin_drop_ship_order_path(@order2)
      page.should have_content(@order2.id)

      click_button 'Confirm Order'
      page.should have_content("We've been notified that you've confirmed this order. To complete the order please, upon shipping, enter the shipping information and click 'Process and finalize order'.")
    end

    it 'confirm - should properly fire for initial send and resend' do
      visit spree.admin_drop_ship_order_path(@order2)
      page.should have_content(@order2.id)

      click_button 'Confirm Order'
      page.should have_content("We've been notified that you've confirmed this order. To complete the order please, upon shipping, enter the shipping information and click 'Process and finalize order'.")

      fill_in 'drop_ship_order[notes]', with: 'Test note.'

      click_button 'Process and finalize order'
      page.should have_content('Thank you for your shipment!')
    end

  end

end
