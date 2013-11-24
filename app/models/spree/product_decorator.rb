Spree::Product.class_eval do

  belongs_to :supplier

  #Spree::PermittedAttributes.user_attributes << :your_attribute
  Spree::PermittedAttributes.product_attributes << :supplier_id
  
  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
