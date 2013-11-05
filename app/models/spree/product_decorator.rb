Spree::Product.class_eval do

  belongs_to :supplier

  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
