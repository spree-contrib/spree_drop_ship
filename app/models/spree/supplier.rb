class Spree::Supplier < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :password, :password_confirmation

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
  validates :email,                  presence: true, email: true, uniqueness: true
  validates :name,                   presence: true, uniqueness: true
  # TODO move to spree_marketplace? not really used anywhere in here
  validates :tax_id,                 length: { is: 9, allow_blank: true }
  validates :url,                    format: { with: URI::regexp(%w(http https)), allow_blank: true }

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :create_stock_location
  after_create :send_welcome, if: -> { SpreeDropShip::Config[:send_supplier_email] }
  before_create :set_commission
  before_validation :check_url

  #==========================================
  # Instance Methods
  scope :active, -> { where(active: true) }

  def deleted?
    deleted_at.present?
  end

  def user_ids_string
    user_ids.join(',')
  end

  def user_ids_string=(s)
    self.user_ids = s.to_s.split(',').map(&:strip)
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

    def check_url
      unless self.url.blank? or self.url =~ URI::regexp(%w(http https))
        self.url = "http://#{self.url}"
      end
    end

    def create_stock_location
      location = self.stock_locations.build(active: true, country_id: self.address.try(:country_id), state_id: self.address.try(:state_id), name: self.name)
      location.save validate: false # It's important location is always created.  Some apps add validations that shouldn't break this.
    end

    def send_welcome
      begin
        Spree::Core::MailMethod.new.deliver!(Spree::SupplierMailer.welcome(self.id))
      rescue Errno::ECONNREFUSED => ex
        Rails.logger.error ex.message
        Rails.logger.error ex.backtrace.join("\n")
        return true # always return true so that failed email doesn't crash app.
      end
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
