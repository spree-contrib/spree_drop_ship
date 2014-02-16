require 'spec_helper'

describe "Stock Management" do

  before do
    @user = create(:supplier_user)
    login_user @user
    visit spree.admin_drop_ship_orders_path
  end

  context "as supplier user" do

    context "given a product with a variant and a stock location" do
      before do
        secondary = create(:stock_location, name: 'Secondary', supplier: @user.supplier)
        @product = create(:product, name: 'apache baseball cap', price: 10, supplier: @user.supplier)
        @v = @product.variants.create!(sku: 'FOOBAR')
        @v.stock_items.first.update_column(:count_on_hand, 10)
        secondary.stock_item(@v).destroy
        click_link "Products"
        within_row(1) do
          click_icon :edit
        end
      end

      it "should not show deleted stock_items" do
        click_link "Stock Management"
        within(:css, '.stock_location_info') do
          page.should have_content(@user.supplier.name)
          page.should_not have_content('Secondary')
        end
      end

      it "can toggle backorderable for a variant's stock item", js: true do
        click_link "Stock Management"

        backorderable = find(".stock_item_backorderable")
        backorderable.should_not be_checked

        backorderable.set(true)

        visit current_path

        backorderable = find(".stock_item_backorderable")
        backorderable.should be_checked
      end

      # Regression test for #2896
      # The regression was that unchecking the last checkbox caused a redirect
      # to happen. By ensuring that we're still on an /admin/products URL, we
      # assert that the redirect is *not* happening.
      it "can toggle backorderable for the second variant stock item", js: true do
        new_location = create(:stock_location, name: "Another Location", supplier: @user.supplier)
        click_link "Stock Management"

        new_location_backorderable = find "#stock_item_backorderable_#{new_location.id}"
        new_location_backorderable.set(false)
        # Wait for API request to complete.
        sleep(1)

        page.current_url.should include("/admin/products")
      end

      it "can create a new stock movement", js: true do
        click_link "Stock Management"

        fill_in "stock_movement_quantity", with: 5
        select2 @user.supplier.name, from: "Stock Location"
        click_button "Add Stock"

        page.should have_content('successfully created')
        within(:css, '.stock_location_info table') do
          column_text(2).should eq '15'
        end
      end

      it "can create a new negative stock movement", js: true do
        click_link "Stock Management"

        fill_in "stock_movement_quantity", with: -5
        select2 @user.supplier.name, from: "Stock Location"
        click_button "Add Stock"

        page.should have_content('successfully created')

        within(:css, '.stock_location_info table') do
          column_text(2).should eq '5'
        end
      end

      it "can create a new negative stock movement", js: true do
        click_link "Stock Management"

        fill_in "stock_movement_quantity", with: -5
        select2 @user.supplier.name, from: "Stock Location"
        click_button "Add Stock"

        page.should have_content('successfully created')

        within(:css, '.stock_location_info table') do
          column_text(2).should eq '5'
        end
      end

      context "with multiple variants" do
        before do
          v = @product.variants.create!(sku: 'SPREEC')
          v.stock_items.first.update_column(:count_on_hand, 30)
        end

        it "can create a new stock movement for the specified variant", js: true do
          click_link "Stock Management"
          fill_in "stock_movement_quantity", with: 10
          select2 "SPREEC", from: "Variant"
          click_button "Add Stock"

          page.should have_content('successfully created')
        end
      end
    end

    # Regression test for #3304
    context "with no stock location" do
      before do
        @product = create(:product, name: 'apache baseball cap', price: 10, supplier: @user.supplier)
        v = @product.variants.create!(sku: 'FOOBAR')
        Spree::StockLocation.delete_all
        click_link "Products"
        within_row(1) do
          click_icon :edit
        end
        click_link "Stock Management"
      end

      it "redirects to stock locations page" do
        page.should have_content(Spree.t(:stock_management_requires_a_stock_location))
        page.current_url.should include("admin/stock_locations")
      end
    end
  end
end
