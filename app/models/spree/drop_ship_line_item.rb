class Spree::DropShipLineItem < ActiveRecord::Base

  attr_accessible :quantity, :price

  belongs_to :drop_ship_order
  belongs_to :line_item

  validates :drop_ship_order_id, presence: true
  validates :price,              presence: true
  validates :quantity,           presence: true
  validates :sku,                presence: true
  validates :variant_id,         presence: true

  def subtotal
    self.quantity.to_i * self.price.to_f
  end

end
