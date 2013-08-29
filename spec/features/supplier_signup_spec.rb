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

  context 'as guest user' do

    after do
      SpreeDropShip::Config.set(allow_signup: false)
    end

    before do
      SpreeDropShip::Config.set(allow_signup: true)
      visit spree.new_supplier_path
      page.should have_content('LOGIN')
    end

    scenario 'as business' do
      fill_in 'supplier[name]', with: 'Spree'
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[password]', with: 'password'
      fill_in 'supplier[password_confirmation]', with: 'password'
      select 'Business', from: 'supplier[merchant_type]'
      fill_in 'supplier[tax_id]', with: '1234567890'
      click_button 'Sign Up'
      page.should have_content('Thank you for signing up!')
      page.should_not have_content('LOGIN')
    end

    scenario 'as individual' do
      fill_in 'supplier[name]', with: 'Spree'
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[password]', with: 'password'
      fill_in 'supplier[password_confirmation]', with: 'password'
      click_button 'Sign Up'
      page.should have_content('Thank you for signing up!')
      page.should_not have_content('LOGIN')
    end
  end

  context 'logged in' do

    before do
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
        fill_in 'supplier[name]', with: 'Test Supplier'
        click_button 'Sign Up'
        page.should have_content('Thank you for signing up!')
      end

      scenario 'should be able to create new business supplier' do
        within '#user-info' do
          click_link 'Sign Up To Become A Supplier'
        end
        select 'Business', from: 'supplier_merchant_type'
        fill_in 'supplier[name]', with: 'Test Supplier'
        fill_in 'supplier[tax_id]', with: '211111111'
        click_button 'Sign Up'
        page.should have_content('Thank you for signing up!')
      end

      scenario 'should display errors with invalid supplier' do
        within '#user-info' do
          click_link 'Sign Up To Become A Supplier'
        end
        click_button 'Sign Up'
        page.should have_content('This field is required.')
      end

    end

  end

end
