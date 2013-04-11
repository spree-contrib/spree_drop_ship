require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    it 'should be able to change supplier' do
      s1 = create(:supplier)
      s2 = create(:supplier)
      product = create :product, supplier: s1

      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select s2.name, from: 'product[supplier_id]'
      click_button 'Update'

      page.should have_content("Product \"#{product.name}\" has been successfully updated!")
      product.reload.supplier_id.should eql(s2.id)
    end

    it 'should display all products' do
      product1 = create :product
      product2 = create :product
      product2.supplier = create(:supplier)
      product2.save
      product3 = create :product
      product3.supplier = create(:supplier)
      product3.save

      login_user create(:admin_user)
      visit spree.admin_products_path

      page.should have_content(product1.name)
      page.should have_content(product2.name)
      page.should have_content(product3.name)
    end

  end

  context 'as Supplier' do

    before do
      @supplier_user = create(:supplier_user)
      @supplier = @supplier_user.supplier
      login_user @supplier_user
    end

    context "searching products works with only suppliers in results" do
      it "should be able to search deleted products", :js => true do
        create(:product, :name => 'apache baseball cap', :deleted_at => "2011-01-06 18:21:13", :supplier => @supplier)
        create(:product, :name => 'zomg shirt', :supplier => @supplier)
        create(:product, :name => 'apache baseball bat', :deleted_at => "2011-01-06 18:21:13")
        create(:product, :name => 'zomg bat')

        visit spree.admin_products_path
        page.should have_content("zomg shirt")
        page.should_not have_content("apache baseball cap")
        page.should_not have_content("apache baseball bat")
        page.should_not have_content("zomg bat")
        check "Show Deleted"
        click_icon :search
        page.should have_content("zomg shirt")
        page.should have_content("apache baseball cap")
        page.should_not have_content("apache baseball bat")
        page.should_not have_content("zomg bat")
        uncheck "Show Deleted"
        click_icon :search
        page.should have_content("zomg shirt")
        page.should_not have_content("apache baseball cap")
        page.should_not have_content("apache baseball bat")
        page.should_not have_content("zomg bat")
      end

      it "should be able to search products by their properties with only suppliers in results" do
        create(:product, :name => 'apache baseball cap', :sku => "A100", :supplier => @supplier)
        create(:product, :name => 'apache baseball cap2', :sku => "B100")
        create(:product, :name => 'zomg shirt')
        create(:product, :name => 'zomg skirt', :supplier => @supplier)

        visit spree.admin_products_path
        fill_in "q_name_cont", :with => "ap"
        click_icon :search
        page.should have_content("apache baseball cap")
        page.should_not have_content("apache baseball cap2")
        page.should_not have_content("zomg shirt")
        page.should_not have_content("zomg skirt")

        fill_in "q_variants_including_master_sku_cont", :with => "A1"
        click_icon :search
        page.should have_content("apache baseball cap")
        page.should_not have_content("apache baseball cap2")
        page.should_not have_content("zomg shirt")
        page.should_not have_content("zomg skirt")
      end
    end

    context "creating a new product from a prototype" do
      def build_option_type_with_values(name, values)
        ot = create(:option_type, :name => name)
        values.each do |val|
          ot.option_values.create({:name => val.downcase, :presentation => val}, :without_protection => true)
        end
        ot
      end

      let(:product_attributes) do
        attributes_for(:simple_product)
      end

      let(:prototype) do
        size = build_option_type_with_values("size", %w(Small Medium Large))
        create(:prototype, :name => "Size", :option_types => [ size ])
      end

      let(:option_values_hash) do
        hash = {}
        prototype.option_types.each do |i|
          hash[i.id.to_s] = i.option_value_ids
        end
        hash
      end

      before(:each) do
        @option_type_prototype = prototype
        @property_prototype = create(:prototype, :name => "Random")
        visit spree.admin_products_path
        click_link "admin_new_product"
        within('#new_product') do
          page.should have_content("SKU")
        end
      end

      it "should allow an supplier to create a new product and variants from a prototype" do
        fill_in "product_name", :with => "Baseball Cap"
        fill_in "product_sku", :with => "B100"
        fill_in "product_price", :with => "100"
        fill_in "product_available_on", :with => "2012/01/24"
        select "Size", :from => "Prototype"
        sleep 10
        check "Large"
        click_button "Create"
        page.should have_content("successfully created!")
        Spree::Product.last.variants.length.should == 1
        # Check suppliers assigned properly
        Spree::Product.last.supplier_id.should eql(@supplier.id)
      end

    end

    context "creating a new product" do

      it "should allow an supplier to create a new product" do
        visit spree.admin_products_path
        click_link "admin_new_product"
        within('#new_product') do
          page.should have_content("SKU")
        end
        fill_in "product_name", :with => "Baseball Cap"
        fill_in "product_sku", :with => "B100"
        fill_in "product_price", :with => "100"
        fill_in "product_available_on", :with => "2012/01/24"
        click_button "Create"
        page.should have_content("successfully created!")
        click_button "Update"
        page.should have_content("successfully updated!")
        # Check suppliers assigned properly
        Spree::Product.last.supplier_id.should eql(@supplier.id)
      end

    end

    context "cloning a product" do
      it "should allow an supplier to clone a product" do
        create(:product, supplier: @supplier)

        visit spree.admin_products_path
        within_row(1) do
          click_icon :copy
        end

        page.should have_content("Product has been cloned")
        # Check suppliers assigned properly
        Spree::Product.last.supplier_id.should eql(@supplier.id)
      end

      context "cloning a deleted product" do
        it "should allow an supplier to clone a deleted product" do
          create(:product, name: "apache baseball cap", supplier: @supplier)
          visit spree.admin_products_path
          check "Show Deleted"
          click_button "Search"

          page.should have_content("apache baseball cap")

          within_row(1) do
            click_icon :copy
          end

          page.should have_content("Product has been cloned")
          # Check suppliers assigned properly
          Spree::Product.last.supplier_id.should eql(@supplier.id)
        end
      end
    end

    context 'updating a product' do
      let(:product) { create(:product, supplier: @supplier) }

      it 'should not display supplier selection' do
        visit spree.admin_product_path(product)
        page.should_not have_css('#product_supplier_id')
      end
    end

  end

end
