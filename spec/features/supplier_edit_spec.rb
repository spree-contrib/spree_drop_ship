require 'spec_helper'

feature 'Supplier editing information', js: true do

  context 'logged in as a user other than the suppliers' do

    it 'should be unauthorized' do
      supplier = create(:supplier)
      login_user create(:user)
      visit spree.edit_supplier_path(@supplier)
      page.should have_content('Unauthorized')
    end

  end

  context 'logged in as a suppliers user' do

    before do
      country = create(:country, name: "United States")
      create(:state, name: "Vermont", country: country)
      @user = create(:user)
      create(:supplier, email: @user.email, users: [@user])
      login_user @user
      visit spree.account_path
    end

    scenario 'should be able to update supplier' do
      within 'dd.supplier-info' do
        click_link 'Edit'
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
      click_button 'Save'
      page.should have_content('Your information has been successfully updated.')
    end

    scenario 'should display errors with invalid supplier update' do
      within 'dd.supplier-info' do
        click_link 'Edit'
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
      click_button 'Save'
      page.should have_content('Address is invalid')
    end

  end

end
