Spree::Shipment.class_eval do

  durably_decorate :after_ship, mode: 'soft', sha: 'c7dd7da83420baf63a8c4dfbc0c4b3ca8d882c52' do
    original_after_ship
    if drop_ship_order and drop_ship_order.shipments.size == drop_ship_order.shipments.shipped.size
      drop_ship_order.complete!
    end
  end

  def drop_ship_order
    order.drop_ship_orders.find_by_supplier_id(stock_location.supplier_id)
  end

end
