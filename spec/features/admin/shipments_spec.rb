require 'spec_helper'

describe 'Admin - Shipments', js: true do

  context 'as Supplier' do

    let!(:order) { build(:order_ready_for_drop_ship, state: 'complete', completed_at: "2011-02-01 12:36:15", number: "R100") }
    let!(:supplier) { create(:supplier) }

    let!(:product) {
      p = create(:product, name: 'spree t-shirt', price: 20.00)
      p.add_supplier! supplier.id
      p
    }

    let!(:shipment) { create(:shipment, order: order, stock_location: supplier.stock_locations.first) }
    let!(:shipping_method) { create(:shipping_method, name: "Default") }

    before do
      # Adjust qoh so shipment will be ready
      shipment.stock_location.stock_items.where(variant_id: product.master.id).first.adjust_count_on_hand(10)
      # Add product and update shipment
      order.contents.add(product.master, 2)
      shipment.refresh_rates
      shipment.update!(order)
      shipment.update_amounts

      # TODO this is a hack until capture_on_dispatch finished https://github.com/spree/spree/issues/4727
      shipment.update_attribute :state, 'ready'

      user = create(:user, supplier: supplier)
      user.generate_spree_api_key!
      login_user user

      visit spree.edit_admin_shipment_path(shipment)
    end

    context 'edit page' do

      it "can add tracking information" do
        within '.table tr.show-tracking' do
          click_icon :edit
        end
        within '.table tr.edit-tracking' do
          fill_in "tracking", with: "FOOBAR"
          click_icon :save
        end
        wait_for_ajax
        within '.table tr.show-tracking' do
          page.should have_content("Tracking: FOOBAR")
        end
      end

      it "can change the shipping method" do
        within(".table tr.show-method") do
          click_icon :edit
        end
        select2 "Default", from: "Shipping Method"
        click_icon :save
        wait_for_ajax

        page.should have_content("Default $0.00")
      end

      it "can ship a completed order" do
        click_on "Ship"
        wait_for_ajax

        page.should have_content("shipped package")
        order.reload.shipment_state.should == "shipped"
      end
    end

    it 'should render unauthorized visiting another suppliers shipment' do
      visit spree.edit_admin_shipment_path(create(:shipment))
      page.should have_content('Authorization Failure')
    end
  end

end
