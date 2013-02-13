require 'spec_helper'

describe Spree::Supplier do

  it { should belong_to(:address) }
  it { should belong_to(:user) }

  it { should have_many(:orders).dependent(:nullify) }
  it { should have_many(:products).through(:supplier_products) }
  it { should have_many(:supplier_products).dependent(:destroy) }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:commission_fee_percentage) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
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

  # after_create :find_or_create_user_and_send_welcome
    #   def find_or_create_user_and_send_welcome
    #     unless user ||= Spree.user_class.find_by_email(email)
    #       password = Digest::SHA1.hexdigest(email.to_s)[0..16]
    #       user = self.create_user(:email => email, :password => password, :password_confirmation => password)
    #       user.send(:generate_reset_password_token!) if user.respond_to?(:generate_reset_password_token!)
    #     end
    #     if Spree::DropShipConfig[:send_supplier_welcome_email]
    #       Spree::SupplierMailer.welcome(self).deliver!
    #     end
    #     self.save
    #   end
    it '#find_or_create_user_and_send_welcome' do
      pending 'need to write...'
    end

end
