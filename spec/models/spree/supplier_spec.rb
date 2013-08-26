require 'spec_helper'

describe Spree::Supplier do

  it { should belong_to(:address) }

  it { should have_many(:orders).dependent(:nullify) }
  it { should have_many(:products) }
  it { should have_many(:stock_locations) }
  it { should have_many(:users) }
  it { should have_many(:variants).through(:products) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }

  it '#business?' do
    subject.business?.should be_false
    subject.merchant_type = 'business'
    subject.business?.should be_true
  end

  it '#email_with_name' do
    subject.name = 'Test'
    subject.email = 'test@test.com'
    subject.email_with_name.should eql('Test <test@test.com>')
  end

  it '#deleted?' do
    subject.deleted_at = nil
    subject.deleted_at?.should eql(false)
    subject.deleted_at = Time.now
    subject.deleted_at?.should eql(true)
  end

  context '#assign_user' do

    before do
      @instance = build(:supplier)
    end

    it 'with user' do
      Spree.user_class.should_not_receive :find_by_email
      @instance.email = 'test@test.com'
      @instance.users << create(:user)
      @instance.save
    end

    it 'with existing user email' do
      user = create(:user, email: 'test@test.com')
      Spree.user_class.should_receive(:find_by_email).with(user.email).and_return(user)
      @instance.email = user.email
      @instance.save
      @instance.reload.users.first.should eql(user)
    end

    it 'without existing user' do
      @instance.email = 'test@example.com'
      @instance.save
      @instance.reload.users.first.email.should eql('test@example.com')
      @instance.reload.users.first.reset_password_sent_at.should_not be_nil
    end

  end

  it '#create_stock_location' do
    Spree::StockLocation.count.should eql(0)
    supplier = create :supplier
    Spree::StockLocation.first.active.should be_true
    Spree::StockLocation.first.country.should eql(supplier.address.country)
    Spree::StockLocation.first.supplier.should eql(supplier)
  end

  context '#send_welcome' do

    after do
      SpreeDropShip::Config[:send_supplier_email] = true
    end

    before do
      @instance = build(:supplier)
      @mail_message = double('Mail::Message')
    end

    context 'with Spree::DropShipConfig[:send_supplier_email] == false' do

      it 'should not send' do
        SpreeDropShip::Config[:send_supplier_email] = false
        Spree::SupplierMailer.should_not_receive(:welcome)
        @mail_message.should_not_receive :deliver!
        @instance.save
      end

    end

    context 'with Spree::DropShipConfig[:send_supplier_email] == true' do

      it 'should send welcome email' do
        Spree::SupplierMailer.should_receive(:welcome).and_return(@mail_message)
        @mail_message.should_receive :deliver!
        @instance.save
      end

    end

  end

  it '#set_commission' do
    SpreeDropShip::Config.set default_commission_flat_rate: 1
    SpreeDropShip::Config.set default_commission_percentage: 1
    supplier = create :supplier
    SpreeDropShip::Config.set default_commission_flat_rate: 0
    SpreeDropShip::Config.set default_commission_percentage: 0
    # Default configuration is 0.0 for each.
    supplier.commission_flat_rate.to_f.should eql(1.0)
    supplier.commission_percentage.to_f.should eql(1.0)
    # With custom commission applied.
    supplier = create :supplier, commission_flat_rate: 123, commission_percentage: 25
    supplier.commission_flat_rate.should eql(123.0)
    supplier.commission_percentage.should eql(25.0)
  end

end
