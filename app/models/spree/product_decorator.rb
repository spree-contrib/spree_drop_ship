Spree::Product.class_eval do

  belongs_to :supplier, touch: true

  Spree::PermittedAttributes.product_attributes << :supplier_id

  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
