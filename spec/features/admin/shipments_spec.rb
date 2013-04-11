require 'spec_helper'

describe 'Admin - Shipments', js: true do

  before do
    @order1 = create(:drop_ship_order)
    @order2 = create(:drop_ship_order)
    @order3 = create(:drop_ship_order)
  end

  context 'as Supplier' do

    before do
      pending 'need to write actual tests'
      @supplier = @order2.supplier
      login_user @supplier
    end

    context 'edit page' do
      before do
        visit spree.edit_admin_drop_ship_order_path(@order2)
      end

      it 'should not display supplier information' do
        page.should_not have_css('[data-hook=admin_order_show_supplier]')
        page.should have_css('[data-hook=admin_order_show_addresses]')
        page.should have_css('[data-hook=admin_order_show_details]')
      end

      it 'should properly display and allow confirmation' do
        click_button 'Confirm Order'
        page.should have_content("We've been notified that you've confirmed this order. To complete the order please, upon shipping, enter the shipping information and click 'Process and finalize order'.")
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

    it 'should render unauthorized visiting another suppliers shipment' do
      visit spree.edit_admin_drop_ship_order_path(@order1)
      page.should have_content('Unauthorized')
    end
  end

end
