require 'spec_helper'

feature 'Supplier Signup', js: true do

  scenario 'existing supplier' do
    @user = create(:user)
    create(:supplier, email: @user.email, users: [@user])
    login_user @user
    visit spree.new_supplier_path
    page.current_path.should eql(spree.account_path)
    page.should have_content("You've already signed up to become a supplier.")
  end

  context 'logged in' do

    before do
      country = create(:country, name: "United States")
      create(:state, name: "Vermont", country: country)
      @user = create(:user)
      login_user @user
    end

    context 'w/ DropShipConfig[:allow_signup] == false (the default)' do

      scenario 'should not be able to create new supplier' do
        visit spree.account_path
        within '#user-info' do
          page.should_not have_link 'Sign Up To Become A Supplier'
        end
        visit spree.new_supplier_path
        page.should have_content('Unauthorized')
      end

    end

    context 'w/ DropShipConfig[:allow_signup] == true' do

      after do
        SpreeDropShip::Config.set(allow_signup: false)
      end

      before do
        SpreeDropShip::Config.set(allow_signup: true)
        visit spree.account_path
      end

      scenario 'should be able to create new individual supplier' do
        within '#user-info' do
          click_link 'Sign Up To Become A Supplier'
        end
        select 'Individual', from: 'supplier_merchant_type'
        select '1970', from: 'supplier_contacts_date_of_birth_1i'
        select 'April', from: 'supplier_contacts_date_of_birth_2i'
        select '20', from: 'supplier_contacts_date_of_birth_3i'
        fill_in 'supplier[name]', with: 'Test Supplier'
        fill_in 'supplier[email]', with: @user.email
        fill_in 'supplier[url]', with: 'http://www.test.com'
        fill_in 'supplier[address_attributes][firstname]', with: 'First'
        fill_in 'supplier[address_attributes][lastname]', with: 'Last'
        fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
        fill_in 'supplier[address_attributes][city]', with: 'Test City'
        fill_in 'supplier[address_attributes][zipcode]', with: '55555'
        select 'United States', from: 'supplier[address_attributes][country_id]'
        select 'Vermont', from: 'supplier[address_attributes][state_id]'
        fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
        click_button 'Sign Up'
        page.should have_content('Thank you for signing up!')
      end

      scenario 'should be able to create new business supplier' do
        within '#user-info' do
          click_link 'Sign Up To Become A Supplier'
        end
        select 'Business', from: 'supplier_merchant_type'
        select '1970', from: 'supplier_contacts_date_of_birth_1i'
        select 'April', from: 'supplier_contacts_date_of_birth_2i'
        select '20', from: 'supplier_contacts_date_of_birth_3i'
        fill_in 'supplier[name]', with: 'Test Supplier'
        fill_in 'supplier[email]', with: @user.email
        fill_in 'supplier[url]', with: 'http://www.test.com'
        fill_in 'supplier[tax_id]', with: '211111111'
        fill_in 'supplier[address_attributes][firstname]', with: 'First'
        fill_in 'supplier[address_attributes][lastname]', with: 'Last'
        fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
        fill_in 'supplier[address_attributes][city]', with: 'Test City'
        fill_in 'supplier[address_attributes][zipcode]', with: '55555'
        select 'United States', from: 'supplier[address_attributes][country_id]'
        select 'Vermont', from: 'supplier[address_attributes][state_id]'
        fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
        click_button 'Sign Up'
        page.should have_content('Thank you for signing up!')
      end

      scenario 'should display errors with invalid supplier' do
        within '#user-info' do
          click_link 'Sign Up To Become A Supplier'
        end
        fill_in 'supplier[name]', with: 'Test Supplier'
        fill_in 'supplier[email]', with: @user.email
        fill_in 'supplier[url]', with: 'http://www.test.com'
        fill_in 'supplier[address_attributes][firstname]', with: ''
        fill_in 'supplier[address_attributes][lastname]', with: 'Last'
        fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
        fill_in 'supplier[address_attributes][city]', with: 'Test City'
        fill_in 'supplier[address_attributes][zipcode]', with: '55555'
        select 'United States', from: 'supplier[address_attributes][country_id]'
        select 'Vermont', from: 'supplier[address_attributes][state_id]'
        fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
        click_button 'Sign Up'
        page.should have_content('This field is required.')
      end

    end

  end

end
