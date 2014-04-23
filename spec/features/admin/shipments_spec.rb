require 'spec_helper'

describe 'Admin - Shipments', js: true do

  context 'as Supplier' do

    let!(:order) { build(:order_ready_for_drop_ship, state: 'complete', completed_at: "2011-02-01 12:36:15", number: "R100") }
    let!(:supplier) { create(:supplier) }

    let!(:product) { create(:product, name: 'spree t-shirt', price: 20.00, supplier: supplier) }

    let!(:stock_location) { supplier.stock_locations.first }
    let!(:shipment) { create(:shipment, order: order, stock_location: stock_location) }

    let!(:shipping_method) { create(:shipping_method, name: "Default") }

    before do
      # Adjust qoh so shipment will be ready
      shipment.stock_location.stock_items.where(variant_id: product.master.id).first.adjust_count_on_hand(10)
      # Add product and update shipment
      order.contents.add(product.master, 2)
      shipment.refresh_rates
      shipment.update!(order)
      shipment.update_amounts

      login_user create(:user, supplier: supplier)
      visit spree.edit_admin_shipment_path(shipment)
    end

    context 'edit page' do

      it "can add tracking information" do
        within 'table.index tr.show-tracking' do
          click_icon :edit
        end
        within 'table.index tr.edit-tracking' do
          fill_in "tracking", :with => "FOOBAR"
          click_icon :ok
        end
        wait_for_ajax
        within 'table.index tr.show-tracking' do
          page.should have_content("Tracking: FOOBAR")
        end
      end

      it "can change the shipping method" do
        within("table.index tr.show-method") do
          click_icon :edit
        end
        select2 "Default", from: "Shipping Method"
        click_icon :ok
        wait_for_ajax

        page.should have_content("Default $0.00")
      end

      it "can ship a completed order" do
        click_link "ship"
        wait_for_ajax

        page.should have_content("SHIPPED PACKAGE")
        order.reload.shipment_state.should == "shipped"
      end
    end

    it 'should render unauthorized visiting another suppliers shipment' do
      visit spree.edit_admin_shipment_path(create(:shipment))
      page.should have_content('Authorization Failure')
    end
  end

end
