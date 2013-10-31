Spree::Product.class_eval do

  belongs_to :supplier
  attr_accessible :supplier_id
  
  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
