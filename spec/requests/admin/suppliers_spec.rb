require 'spec_helper'

describe 'Admin - Suppliers', js: true do

  stub_authorization!

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
    visit spree.admin_path
    within 'ul[data-hook=admin_tabs]' do
      click_link 'Suppliers'
    end
    page.should have_content('Listing Suppliers')
  end

  it 'should be able to create new supplier' do
    click_link 'New Supplier'
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
    click_button 'Create'
    wait_until do
      within 'table.index' do
        page.should have_content('Test Supplier')
      end
    end
  end

end
