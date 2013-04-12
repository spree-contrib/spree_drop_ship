require 'spec_helper'

describe 'Admin - Drop Ship Orders', js: true do

  before do
    @order1 = create(:drop_ship_order)
    @order2 = create(:drop_ship_order)
    @order3 = create(:drop_ship_order, completed_at: Time.now)
  end

  context 'as Admin' do

    before do
      login_user create(:admin_user)
    end

    context 'edit page' do
      before do
        visit spree.edit_admin_drop_ship_order_path(@order1)
        page.should have_content(@order1.id)
      end

      it 'should display supplier information' do
        page.should have_css('[data-hook=admin_order_show_supplier]')
        page.should have_css('[data-hook=admin_order_show_addresses]')
        page.should have_css('[data-hook=admin_order_show_details]')
      end

      it 'deliver button should properly fire for initial send and resend' do
        click_link 'Send Order To Supplier'
        page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order1.id))

        click_link 'Resend Order To Supplier'
        page.should have_content(I18n.t('spree.admin.drop_ship_orders.deliver.success', number: @order1.id))
      end
    end

    context 'index page' do
      it 'should display all drop ship orders with incomplete only by default' do
        visit spree.admin_drop_ship_orders_path

        page.should have_content(@order1.id)
        page.should have_content(@order2.id)
        page.should_not have_content(@order3.id)

        uncheck 'completed_at_is_null'
        page.should have_content(@order1.id)
        page.should have_content(@order2.id)
        page.should have_content(@order3.id)
      end
    end
  end

  context 'as Supplier' do

    before do
      @supplier = @order2.supplier
      login_user create(:user, supplier: @supplier)
    end

    context 'edit page' do
      before do
        visit spree.edit_admin_drop_ship_order_path(@order2)
      end

      it 'should not display admin only information / links' do
        # Order tabs in right column
        page.should_not have_link('Order Details')
        page.should_not have_link('Customer Details')
        page.should_not have_link('Adjustments')
        page.should_not have_link('Payments')
        page.should_not have_link('Return Authorizations')
        # Page Actions
        page.should_not have_link('Send Order To Supplier')
        # Supplier Info
        page.should_not have_css('[data-hook=admin_order_show_supplier]')
        page.should have_css('[data-hook=admin_order_show_addresses]')
        page.should have_css('[data-hook=admin_order_show_details]')
      end

      it 'should properly display and allow confirmation' do
        click_button 'Confirm Order'
        page.should have_content(I18n.t('spree.admin.drop_ship_orders.confirm.success', number: @order1.id))
      end

      it 'should render unauthorized when trying to access another suppliers orders' do
        visit spree.edit_admin_drop_ship_order_path(@order1)
        page.should have_content('Unauthorized')
      end
    end

    context 'index page' do
      it 'should only display the suppliers orders' do
        visit spree.admin_drop_ship_orders_path

        page.should_not have_content(@order1.id)
        page.should have_content(@order2.id)
        page.should_not have_content(@order3.id)
      end
    end
  end

end
