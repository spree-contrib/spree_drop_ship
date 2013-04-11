require 'spec_helper'

describe "Admin - Properties" do

  context 'as Supplier' do

    before do
      @supplier_user = create(:supplier_user)
      @supplier = @supplier_user.supplier
      login_user @supplier_user
      visit spree.admin_products_path
    end

    context "listing product properties" do
      it "should list the existing product properties" do
        create(:property, :name => 'shirt size', :presentation => 'size')
        create(:property, :name => 'shirt fit', :presentation => 'fit')

        click_link "Properties"
        within_row(1) do
          column_text(1).should == "shirt size"
          column_text(2).should == "size"
        end

        within_row(2) do
          column_text(1).should == "shirt fit"
          column_text(2).should == "fit"
        end
      end
    end

    context "creating a property" do
      it "should allow an admin to create a new product property", :js => true do
        pending 'Not sure if we want to allow this yet.'
        # click_link "Properties"
        # click_link "new_property_link"
        # within('#new_property') { page.should have_content("New Property") }
        # 
        # fill_in "property_name", :with => "color of band"
        # fill_in "property_presentation", :with => "color"
        # click_button "Create"
        # page.should have_content("successfully created!")
      end
    end

    context "editing a property" do
      before(:each) do
        pending 'Not sure if we want to allow this yet.'
        # create(:property)
        # click_link "Properties"
        # within_row(1) { click_icon :edit }
      end

      # it "should allow an admin to edit an existing product property" do
      #   fill_in "property_name", :with => "model 99"
      #   click_button "Update"
      #   page.should have_content("successfully updated!")
      #   page.should have_content("model 99")
      # end
      # 
      # it "should show validation errors" do
      #   fill_in "property_name", :with => ""
      #   click_button "Update"
      #   page.should have_content("Name can't be blank")
      # end
    end

    context "linking a property to a product", :js => true do
      before do
        create(:product, supplier: @supplier)
        visit spree.admin_products_path
        click_icon :edit
        click_link "Product Properties"
      end

      # Regression test for #2279
      specify do
        page.should have_content('Editing Product')
        fill_in "product_product_properties_attributes_0_property_name", :with => "A Property"
        fill_in "product_product_properties_attributes_0_value", :with => "A Value"
        click_button "Update"
        click_link "Product Properties"
        page.should have_css("tbody#product_properties")
        all("tbody#product_properties tr").count.should == 2
      end
    end
  end
end
