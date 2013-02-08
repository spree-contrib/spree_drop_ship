class Spree::SupplierProduct < ActiveRecord::Base

  #==========================================
  # Associations

  belongs_to :supplier
  attr_accessible :supplier_id

  belongs_to :product

  #==========================================
  # Validations

  validates_associated :supplier
  validates_associated :product
  validates :supplier_id, :presence => true
  validates :product_id, :presence => true

end