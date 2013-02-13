class Spree::SupplierProduct < ActiveRecord::Base

  #==========================================
  # Associations

  belongs_to :product

  belongs_to :supplier
  attr_accessible :supplier_id

  #==========================================
  # Validations

  validates_associated :product
  validates :product_id, :presence => true

  validates_associated :supplier
  validates :supplier_id, :presence => true

end