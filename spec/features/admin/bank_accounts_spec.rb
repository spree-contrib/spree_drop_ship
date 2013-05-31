require 'spec_helper'

feature 'Admin - Supplier Bank Accounts', js: true do

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
    @supplier = create :supplier
  end

  context 'as a Supplier' do

    before do
      @user = create(:supplier_user)
      login_user @user
      visit spree.account_path
      within 'dd.supplier-info' do
        click_link 'Edit'
      end
    end

    scenario 'adding and verifying bank accounts should work' do
      click_link 'Add Bank Account'
      fill_in 'supplier_bank_account[name]', with: 'Test Supplier'
      fill_in 'supplier_bank_account[account_number]', with: '9900000002'
      fill_in 'supplier_bank_account[routing_number]', with: '021000021'
      select2 'Checking', from: 'Type'
      click_button 'Save'
      page.should have_content('xxxxxx0002 - Unverified')
      page.should have_content('Two small deposits will be made within 2 business days.  Please verify your bank account once you know the amounts.')

      click_link 'Verify'
      fill_in 'supplier_bank_account[amount_1]', with: '1'
      fill_in 'supplier_bank_account[amount_2]', with: '1'
      click_button 'Verify'
      page.should have_content('xxxxxx0002 - Verified')
    end

  end

end
