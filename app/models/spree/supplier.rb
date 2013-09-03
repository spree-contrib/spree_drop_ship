class Spree::Supplier < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :merchant_type

  attr_accessible :address_attributes,
                  :active,
                  :commission_flat_rate,
                  :commission_percentage,
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

  if defined?(Ckeditor::Asset)
    has_many :ckeditor_pictures
    has_many :ckeditor_attachment_files
  end
  has_many   :orders, class_name: 'Spree::DropShipOrder', dependent: :nullify
  has_many   :products
  has_many   :stock_locations
  has_many   :users, class_name: Spree.user_class.to_s
  has_many   :variants, through: :products

  #==========================================
  # Validations

  validates :commission_flat_rate,   presence: true
  validates :commission_percentage,  presence: true
  validates :email,                  presence: true, email: true
  validates :name,                   presence: true, uniqueness: true
  validates :tax_id,                 presence: { if: -> { self.merchant_type == 'business' } }, length: { within: 4..10, allow_blank: true }
  validates :url,                    format: { with: URI::regexp(%w(http https)), allow_blank: true }

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :create_stock_location
  after_create :send_welcome, if: -> { SpreeDropShip::Config[:send_supplier_email] }
  before_create :set_commission

  #==========================================
  # Instance Methods

  scope :active, -> { where(active: true) }

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
      if self.users.empty?
        if user = Spree.user_class.find_by_email(self.email)
          self.users << user
          self.save
        end
      end
    end

    def create_stock_location
      self.stock_locations.create(active: true, country_id: self.address.try(:country_id), state_id: self.address.try(:state_id), name: self.name)
    end

    def send_welcome
      Spree::SupplierMailer.welcome(self.id).deliver!
    end

    def set_commission
      unless changes.has_key?(:commission_flat_rate)
        self.commission_flat_rate = SpreeDropShip::Config[:default_commission_flat_rate]
      end
      unless changes.has_key?(:commission_percentage)
        self.commission_percentage = SpreeDropShip::Config[:default_commission_percentage]
      end
    end

end
