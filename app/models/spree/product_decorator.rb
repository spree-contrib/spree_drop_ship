Spree::Product.class_eval do

  has_one :supplier, :through => :supplier_product
  has_one :supplier_product, :dependent => :destroy

  # Returns true if the product has a drop shipping supplier
  def has_supplier?
    supplier_product.present? && supplier.present?
  end

end
