Spree::Order.class_eval do

  has_many :drop_ship_orders

  def finalize_with_drop_ship!
    finalize_without_drop_ship!

    self.line_items.group_by{ |li| li.product.supplier_id }.each do |supplier_id, supplier_items|
      if supplier_id.present?
        supplier = Spree::Supplier.find(supplier_id)
        dso = supplier.orders.create({:order_id => self.id}, without_protection: true)
        supplier_items.each do |line_item|
          dso.drop_ship_line_items.create({line_item_id: line_item.id}, without_protection: true)
        end
        if Spree::DropShipConfig[:automatically_deliver_orders_to_supplier]
          dso.deliver!
        end
      end
    end
  end
  alias_method_chain :finalize!, :drop_ship

end
