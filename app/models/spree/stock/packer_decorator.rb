Spree::Stock::Packer.class_eval do
  durably_decorate :default_package, mode: 'soft', sha: '96ea67bfbef8dfd4ef6c741730b2c5c5a9ef175d' do
    package = Spree::Stock::Package.new(stock_location, order)
    order.line_items.each do |line_item|

      # Skip if product supplier does not own this stock location
      next if line_item.product.supplier_id.present? and !line_item.product.supplier.stock_locations.pluck(:id).include?(stock_location.id)

      if Spree::Config.track_inventory_levels
        next unless stock_location.stock_item(line_item.variant)

        on_hand, backordered = stock_location.fill_status(line_item.variant, line_item.quantity)
        package.add line_item.variant, on_hand, :on_hand if on_hand > 0
        package.add line_item.variant, backordered, :backordered if backordered > 0
      else
        package.add line_item.variant, line_item.quantity, :on_hand
      end
    end
    package
  end
end
