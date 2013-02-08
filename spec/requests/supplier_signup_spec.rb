require 'spec_helper'

feature 'Supplier Signup', js: true do

  scenario 'guests get redirected to login' do
    visit spree.new_supplier_path
    page.should have_content('Must Be Logged In')
  end

  context 'logged in' do

    before do
      country = create(:country, name: "United States")
      create(:state, name: "Vermont", country: country)
      user = create :user
      user.reload
      visit spree.root_path
      click_link 'Login'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'secret'
      click_button 'Login'
      click_link 'My Account'
    end

    scenario 'should be able to create new supplier' do
      within '#user-info' do
        click_link 'Signup To Become A Supplier'
      end
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[phone]', with: '555-555-5555'
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
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[phone]', with: '555-555-5555'
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
