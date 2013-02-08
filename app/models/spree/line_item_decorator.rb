Spree::LineItem.class_eval do

  scope :will_drop_ship, where("supplier_id IS NOT NULL")

  belongs_to :supplier

  before_validation :set_supplier_id

  def set_supplier_id
    id = variant.product.supplier_product.supplier_id rescue nil
    self.supplier_id = id if id && variant.product.has_supplier?
  end

  def has_supplier?
    supplier_id.present?
  end

  def drop_ship_attributes
    {
      :variant_id => variant_id,
      :sku        => variant ? variant.sku : nil,
      :name       => variant && variant.product ? variant.product.name : nil,
      :quantity   => quantity,
      :price      => price
    }
  end

end
