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
    fill_in 'default_commission_percentage', with: 10
    fill_in 'default_commission_flat_rate', with: 0.30
    uncheck 'send_supplier_welcome_email'
    click_button 'Update'
    page.should have_content('Drop ship settings successfully updated.')
  end

end
