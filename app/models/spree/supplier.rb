class Spree::Supplier < ActiveRecord::Base

  attr_accessible :address_attributes, :commission_flat_rate, :commission_percentage, :email, :name, :url, :user_ids

  #==========================================
  # Associations

  belongs_to :address, class_name: 'Spree::Address'
  accepts_nested_attributes_for :address

  has_many   :orders, class_name: "Spree::DropShipOrder", dependent: :nullify
  has_many   :products
  has_many   :stock_locations
  has_many   :users, class_name: Spree.user_class.to_s

  #==========================================
  # Validations

  validates_associated :address
  validates :address,               presence: true
  validates :commission_flat_rate,  presence: true
  validates :commission_percentage, presence: true
  validates :email,                 presence: true, email: true
  validates :name,                  presence: true, uniqueness: true
  validates :url,                   format: { with: URI::regexp(%w(http https)), allow_blank: true }

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :create_stock_location
  after_create :send_welcome, if: -> { Spree::DropShipConfig[:send_supplier_welcome_email] }
  before_validation :set_commission

  #==========================================
  # Instance Methods

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
      if self.commission_flat_rate.blank?
        self.commission_flat_rate = Spree::DropShipConfig[:default_commission_flat_rate]
      end
      if self.commission_percentage.blank?
        self.commission_percentage = Spree::DropShipConfig[:default_commission_percentage]
      end
    end

end
