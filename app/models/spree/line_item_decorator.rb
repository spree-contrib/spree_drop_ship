Spree::LineItem.class_eval do

  belongs_to :supplier

  has_one :drop_ship_line_item

  before_validation :set_supplier_id

  scope :will_drop_ship, where("supplier_id IS NOT NULL")

  def drop_ship_attributes
    {
      :line_item_id => id,
      :name         => variant && variant.product ? variant.product.name : nil,
      :price        => price,
      :quantity     => quantity,
      :sku          => variant ? variant.sku : nil,
      :variant_id   => variant_id
    }
  end

  def has_supplier?
    supplier_id.present?
  end

  private

  def set_supplier_id
    self.supplier_id = variant.product.supplier_id if variant.product.has_supplier?
  end

end
