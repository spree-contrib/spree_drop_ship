Spree::Shipment.class_eval do

  durably_decorate :after_ship, mode: 'soft', sha: 'd0665a43fd8805f9fd1958b988e35f12f4cee376' do
    original_after_ship
    if drop_ship_order and drop_ship_order.shipments.size == drop_ship_order.shipments.shipped.size
      drop_ship_order.complete!
    end
  end

  def drop_ship_order
    order.drop_ship_orders.find_by_supplier_id(stock_location.supplier_id)
  end

end
