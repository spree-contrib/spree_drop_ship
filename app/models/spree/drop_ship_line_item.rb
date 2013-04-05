class Spree::DropShipLineItem < ActiveRecord::Base

  belongs_to :drop_ship_order
  belongs_to :line_item

end
