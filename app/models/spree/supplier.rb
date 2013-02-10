class Spree::Supplier < ActiveRecord::Base

  attr_accessible :address_attributes, :contact_email, :contact_phone, :email, :name, :phone, :url

  #==========================================
  # Associations

  belongs_to :address, class_name: 'Spree::Address'
  accepts_nested_attributes_for :address
  belongs_to :user, class_name: Spree.user_class.to_s

  has_many   :orders, :class_name => "Spree::DropShipOrder", :dependent => :nullify
  has_many   :products, :through => :supplier_products
  has_many   :supplier_products, :dependent => :destroy

  #==========================================
  # Validations

  validates_associated :address
  validates :address, :name, :phone, :presence => true
  validates :email, :presence => true, :email => true
  validates :url, format: { with: URI::regexp(%w(http https)) }

  #==========================================
  # Callbacks

  after_create :create_user_and_send_welcome

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

    def create_user_and_send_welcome
      unless user
        password = Digest::SHA1.hexdigest(email.to_s)[0..16]
        user = self.create_user(:email => email, :password => password, :password_confirmation => password)
        user.send(:generate_reset_password_token!) if user.respond_to?(:generate_reset_password_token!)
      end
      Spree::SupplierMailer.welcome(self).deliver!
      self.save
    end

end
