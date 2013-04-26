Spree::Shipment.class_eval do

  def after_ship_with_drop_ship
    after_ship_without_drop_ship
    if drop_ship_order and drop_ship_order.shipments.size == drop_ship_order.shipments.shipped.size
      drop_ship_order.complete!
    end
  end
  alias_method_chain :after_ship, :drop_ship

  def drop_ship_order
    order.drop_ship_orders.find_by_supplier_id(stock_location.supplier_id)
  end

end
