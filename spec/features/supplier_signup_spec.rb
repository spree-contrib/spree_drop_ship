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

  scenario 'guests get redirected to login' do
    visit spree.new_supplier_path
    page.should have_content('Must Be Logged In')
  end

  context 'logged in' do

    before do
      country = create(:country, name: "United States")
      create(:state, name: "Vermont", country: country)
      @user = create(:user)
      login_user @user
      visit spree.account_path
    end

    scenario 'should be able to create new supplier' do
      within '#user-info' do
        click_link 'Signup To Become A Supplier'
      end
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
      click_button 'Signup'
      page.should have_content('Thank you for signing up!')
    end

    scenario 'should display errors with invalid supplier' do
      within '#user-info' do
        click_link 'Signup To Become A Supplier'
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
      click_button 'Signup'
      page.should have_content('Address is invalid')
    end

  end

end
