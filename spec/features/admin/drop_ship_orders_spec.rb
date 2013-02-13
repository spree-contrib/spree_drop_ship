require 'spec_helper'

describe 'Admin - Drop Ship Orders', js: true do

  context 'as Admin' do

    before do
      login_user create(:admin_user)
    end

    it 'index - should display all drop ship orders' do
      order1 = create(:drop_ship_order)
      order2 = create(:drop_ship_order)
      order3 = create(:drop_ship_order)

      visit spree.admin_drop_ship_orders_path

      page.should have_content(order1.id)
      page.should have_content(order2.id)
      page.should have_content(order3.id)
    end

    it 'show - should render properly' do
      order = create(:drop_ship_order)

      visit spree.admin_drop_ship_order_path(order)
      page.should have_content(order.id)
    end

    it 'deliver - should properly fire for initial send and resend' do
      order = create(:drop_ship_order)
      visit spree.admin_drop_ship_order_path(order)
      page.should have_content(order.id)

      click_link 'Send Order to Supplier'
      # page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: order.id))

      click_link 'Resend Order to Supplier'
      # page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: order.id))
    end

  end

  context 'as Supplier' do

    it 'should only display the suppliers orders' do
      pending 'need to write'
    end

  end

end
