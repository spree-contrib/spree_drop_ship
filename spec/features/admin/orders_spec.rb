require 'spec_helper'

describe 'Admin - Orders', js: true do

  it 'Supplier should not be authorized' do
    create(:user) # create extra user so admin role isnt assigned to the user we login as
    login_user create(:supplier_user)
    visit spree.admin_orders_path
    page.should have_content('Unauthorized')
  end

  context 'as Admin' do

    before do
      login_user create(:admin_user)
    end

    context 'index page' do

      it 'should display all orders' do
        order1 = create(:drop_ship_order)
        order2 = create(:drop_ship_order)
        order3 = create(:drop_ship_order)

        visit spree.admin_orders_path

        page.should have_content(order1.order.number)
        page.should have_content(order2.order.number)
        page.should have_content(order3.order.number)
      end

    end

    context 'edit page' do
      before do
        drop_ship_order = create(:drop_ship_order)
        visit spree.edit_admin_order_path(drop_ship_order.order.number)
        page.should have_content(drop_ship_order.id)
        page.should have_content(drop_ship_order.order.number)
      end

      it 'displays drop ship order info' do
        pending 'should check useful information is displayed for drop ship orders'
      end
    end

  end

end
