require 'spec_helper'

describe 'Admin - Shipments', js: true do

  context 'as Supplier' do

    before do
      new_method = create(:shipping_method, :name => "Newer")
      @order = create(:order_ready_for_drop_ship).drop_ship_orders.first
      @supplier = @order.supplier
      @order.shipments.each do |ship|
        ship.add_shipping_method new_method, false
      end
      login_user create(:user, supplier: @supplier)
    end

    context 'edit page' do

      it "can add tracking information" do
        visit spree.edit_admin_drop_ship_order_path(@order)
        within 'table.index tr.show-tracking' do
          click_icon :edit
        end
        within 'table.index tr.edit-tracking' do
          fill_in "tracking", :with => "FOOBAR"
          click_icon :ok
        end
        within 'table.index tr.show-tracking' do
          page.should have_content("Tracking: FOOBAR")
        end
      end

      it "can change the shipping method" do
        visit spree.edit_admin_drop_ship_order_path(@order)
        within("table.index tr.show-method") do
          click_icon :edit
        end
        select2 "Newer", :from => "Shipping Method"
        click_icon :ok

        page.should have_content("Newer:")
      end

      it 'can ship' do
        visit spree.edit_admin_drop_ship_order_path(@order)
        click_icon 'arrow-right'
        sleep 1
        within '.shipment-state' do
          page.should have_content('SHIPPED')
        end
      end
    end

    it 'should render unauthorized visiting another suppliers shipment' do
      visit spree.edit_admin_drop_ship_order_path(create(:drop_ship_order))
      page.should have_content('Unauthorized')
    end
  end

end
