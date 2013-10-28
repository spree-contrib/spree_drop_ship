Spree::Product.class_eval do

  belongs_to :supplier
  attr_accessible :supplier_id

  attr_accessible :name, :permalink, :description, :price, :cost_price, :cost_currency, :available_on, :shipping_category_id, :tax_category_id, :taxon_ids, :option_type_ids, :meta_keywords, :meta_description
  
  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
