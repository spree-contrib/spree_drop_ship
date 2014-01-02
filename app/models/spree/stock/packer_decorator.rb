Spree::Stock::Packer.class_eval do
  durably_decorate :default_package, mode: 'soft', sha: '9c083e11e00a15a78b8b6df0478666e727f8fe3e' do
    package = Package.new(stock_location, order)
    order.line_items.each do |line_item|

      # Skip if product supplier does not own this stock location
      next if line_item.product.supplier_id.present? and !line_item.product.supplier.stock_locations.pluck(:id).include?(stock_location.id)

      if line_item.should_track_inventory?
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
