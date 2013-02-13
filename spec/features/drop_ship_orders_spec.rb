require 'spec_helper'

describe 'Drop Ship Orders', js: true do

  context 'without access' do
    before do
      login_user
      @order = create(:drop_ship_order)
    end
    it 'should redirect on another users orders' do
      visit spree.drop_ship_order_path(@order)
      page.should have_content('Unauthorized')
    end
  end

  context 'as Supplier' do

    before do
      @user = create(:supplier).user
      @order = create(:drop_ship_order, supplier: @user.supplier)

      login_user @user
    end

    it 'show - should render properly' do
      visit spree.drop_ship_order_path(@order)
      page.should have_content(@order.id)
    end

    it 'edit - should properly fire for initial send and resend' do
      visit spree.drop_ship_order_path(@order)
      page.should have_content(@order.id)

      click_link 'Edit'
      click_link 'Confirm'
      # page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.drop_ship_orders.confirm.success', number: @order.id))
    end

    it 'confirm - should properly fire for initial send and resend' do
      visit spree.drop_ship_order_path(@order)
      page.should have_content(@order.id)

      click_link 'Confirm'
      # page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.drop_ship_orders.confirm.success', number: @order.id))
    end

  end

end
