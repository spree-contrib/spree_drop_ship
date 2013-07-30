Spree::Shipment.class_eval do
  puts "Shipment#after_ship SHA: #{DurableDecorator::Base.determine_sha('Spree::Shipment#after_ship')}"
  # TODO Using soft here since a strict is causing issues in one app but not another for some reason even when sha is coming out correct...
  durably_decorate :after_ship, mode: 'soft', sha: 'c7dd7da83420baf63a8c4dfbc0c4b3ca8d882c52' do
    after_ship_original
    if drop_ship_order and drop_ship_order.shipments.size == drop_ship_order.shipments.shipped.size
      drop_ship_order.complete!
    end
  end

  def drop_ship_order
    order.drop_ship_orders.find_by_supplier_id(stock_location.supplier_id)
  end

end
