class Spree::Supplier < ActiveRecord::Base

  attr_accessible :address_attributes,
                  :commission_flat_rate,
                  :commission_percentage,
                  :contacts_date_of_birth,
                  :email,
                  :merchant_type,
                  :name,
                  :tax_id,
                  :url,
                  :user_ids

  #==========================================
  # Associations

  belongs_to :address, class_name: 'Spree::Address'
  accepts_nested_attributes_for :address

  has_many   :bank_accounts, class_name: 'Spree::SupplierBankAccount'
  has_many   :orders, class_name: 'Spree::DropShipOrder', dependent: :nullify
  has_many   :products
  has_many   :stock_locations
  has_many   :users, class_name: Spree.user_class.to_s
  has_many   :variants, through: :products
  if defined?(Ckeditor::Picture) && defined?(Ckeditor::AttachmentFile)
    has_many :ckeditor_pictures
    has_many :ckeditor_attachment_files
  end

  #==========================================
  # Validations

  validates_associated :address
  validates :address,                presence: true
  validates :commission_flat_rate,   presence: true
  validates :commission_percentage,  presence: true
  validates :contacts_date_of_birth, presence: true
  validates :email,                  presence: true, email: true
  validates :name,                   presence: true, uniqueness: true
  validates :tax_id,                 presence: { if: :business? }
  validates :url,                    format: { with: URI::regexp(%w(http https)), allow_blank: true }

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :create_stock_location
  after_create :send_welcome, if: -> { SpreeDropShip::Config[:send_supplier_email] }
  before_create :set_commission
  before_create :set_token

  #==========================================
  # Instance Methods

  def business?
    self.merchant_type == 'business'
  end

  # Returns the supplier's email address and name in mail format
  def email_with_name
    "#{name} <#{email}>"
  end

  def deleted?
    deleted_at.present?
  end

  #==========================================
  # Protected Methods

  protected

    def assign_user
      if self.users.empty? and user = Spree.user_class.find_by_email(self.email)
        self.users << user
        self.save
      end
    end

    def create_stock_location
      self.stock_locations.create(active: true, country_id: self.address.country_id, name: self.name)
    end

    def send_welcome
      Spree::SupplierMailer.welcome(self).deliver!
    end

    def set_commission
      unless changes.has_key?(:commission_flat_rate)
        self.commission_flat_rate = SpreeDropShip::Config[:default_commission_flat_rate]
      end
      unless changes.has_key?(:commission_percentage)
        self.commission_percentage = SpreeDropShip::Config[:default_commission_percentage]
      end
    end

    def set_token
      Balanced.configure(SpreeDropShip::Config[:balanced_api_key])
      marketplace = Balanced::Marketplace.my_marketplace
      account     = Balanced::Marketplace.my_marketplace.create_account
      self.token  = account.uri
      if self.merchant_type == 'individual'
        merchant_data = {
          :dob => self.contacts_date_of_birth.strftime('%Y-%m-%d'),
          :name => self.address.full_name,
          :phone_number => self.address.phone,
          :postal_code => self.address.zipcode,
          :street_address => self.address.address1,
          :type => 'person'
        }
      elsif self.merchant_type == 'business'
        merchant_data = {
          :name => self.name,
          :phone_number => self.address.phone,
          :postal_code => self.address.zipcode,
          :street_address => self.address.address1,
          :tax_id => self.tax_id,
          :type => 'business',
          :person => {
            :dob => self.contacts_date_of_birth.strftime('%Y-%m-%d'),
            :phone_number => self.address.phone,
            :postal_code => self.address.zipcode,
            :name => self.address.full_name,
            :street_address => self.address.address1,
          },
        }
      end
      account.promote_to_merchant(merchant_data)
    end

end
