require 'spec_helper'

describe Spree::Supplier do

  it { should belong_to(:address) }
  it { should belong_to(:user) }

  it { should have_many(:orders).dependent(:nullify) }
  it { should have_many(:products) }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:commission_fee_percentage) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:phone) }

  # TODO
  # validates :email, email: true
  # validates :url, format: { with: URI::regexp(%w(http https)), allow_blank: true }

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

  context '#find_or_create_user_and_send_welcome' do

    context 'with Spree::DropShipConfig[:send_supplier_welcome_email] == false' do

      before do
        Spree::DropShipConfig[:send_supplier_welcome_email] = false
        @instance = build(:supplier)
        mail_message = mock('Mail::Message')
        mail_message.should_not_receive :deliver!
        Spree::SupplierMailer.should_not_receive(:welcome).with(@instance)
      end

      it 'with user' do
        @instance.email = 'test@test.com'
        @instance.user = create(:user)
        @instance.should_not_receive(:create_user)
        # Spree.user_class.should_not_recieve(:find_by_email).with('test@test.com')
        @instance.save
      end

      it'with existing user email' do
        user = create(:user, email: 'test@test.com')
        @instance.email = 'test@test.com'
        @instance.user = nil
        @instance.should_not_receive(:create_user)
        @instance.save
      end

      it'without user or existing user email' do
        @instance.should_receive(:create_user)
        @instance.email = 'test@test.com'
        @instance.user = nil
        @instance.save
      end

    end

    context 'with Spree::DropShipConfig[:send_supplier_welcome_email] == true' do

      it 'should send welcome email' do
        Spree::DropShipConfig[:send_supplier_welcome_email] = true
        @instance = build :supplier, user: create(:user)
        mail_message = mock('Mail::Message')
        mail_message.should_receive :deliver!
        Spree::SupplierMailer.should_receive(:welcome).with(@instance).and_return(mail_message)
        @instance.save
      end

    end

  end

end
