require 'spec_helper'

describe 'Admin - Orders', js: true do

  context 'as Admin' do

    before do
      login_user create(:admin_user)
    end

    it 'index - should display all orders' do
      order1 = create(:drop_ship_order)
      order2 = create(:drop_ship_order)
      order3 = create(:drop_ship_order)

      visit spree.admin_orders_path

      page.should have_content(order1.order.number)
      page.should have_content(order2.order.number)
      page.should have_content(order3.order.number)
    end

    it 'show - should render properly' do
      drop_ship_order = create(:drop_ship_order)

      visit spree.admin_order_path(drop_ship_order.order)
      page.should have_content(drop_ship_order.order.number)
      # TODO make this check within a proper scope
      page.should have_content(drop_ship_order.id)
    end

    it 'approve - should properly fire' do
      drop_ship_order = create(:drop_ship_order)
      visit spree.admin_order_path(drop_ship_order.order)
      page.should have_content(drop_ship_order.order.number)

      click_link 'Approve Drop Ship Orders'
      page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.orders_sent'))

      click_link 'Resend Drop Ship Orders'
      page.driver.browser.switch_to.alert.accept
      page.should have_content(I18n.t('spree.admin.drop_ship_orders.orders_sent'))
    end

  end

  context 'as Supplier' do

    it 'should not be accessible' do
      pending 'need to write'
    end

  end

end
