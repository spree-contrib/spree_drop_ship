require 'spec_helper'

describe 'Admin - Drop Ship Settings', js: true do

  before do
    login_user create(:admin_user)

    visit spree.admin_path
    within 'ul[data-hook=admin_tabs]' do
      click_link 'Configuration'
    end
    within 'ul[data-hook=admin_configurations_sidebar_menu]' do
      click_link 'Drop Ship Settings'
    end
  end

  it 'should be able to be updated' do
    # Change settings
    check 'allow_signup'
    uncheck 'automatically_deliver_orders_to_supplier'
    fill_in 'balanced_api_key', with: 'test'
    fill_in 'default_commission_flat_rate', with: 0.30
    fill_in 'default_commission_percentage', with: 10
    uncheck 'send_supplier_email'
    click_button 'Update'
    page.should have_content('Drop ship settings successfully updated.')

    # Verify update saved properly by reversing checkboxes or checking field values.
    uncheck 'allow_signup'
    check 'automatically_deliver_orders_to_supplier'
    find_field('balanced_api_key').value.should eql('test')
    find_field('default_commission_flat_rate').value.to_f.should eql(0.3)
    find_field('default_commission_percentage').value.to_f.should eql(10.0)
    check 'send_supplier_email'
    click_button 'Update'
    page.should have_content('Drop ship settings successfully updated.')
  end

end
