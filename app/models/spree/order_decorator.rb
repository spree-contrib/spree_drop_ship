Spree::Order.class_eval do

  has_many :drop_ship_orders

  # Once order is finalized we want to notify the suppliers of their drop ship orders.
  # Here we are handling notification by emailing the suppliers.
  # If you want to customize this you could override it as a hook for notifying a supplier with a API request instead.
  def finalize_with_drop_ship!
    finalize_without_drop_ship!
    create_drop_ship_orders
    if SpreeDropShip::Config[:automatically_deliver_orders_to_supplier]
      drop_ship_orders.each &:deliver!
    end
  end
  alias_method_chain :finalize!, :drop_ship

  private

  # Destroy any existing drop ship orders and recreate fresh ones for accurracy.
  def create_drop_ship_orders
    self.drop_ship_orders.destroy_all
    self.line_items.group_by{ |li| li.product.supplier_id }.each do |supplier_id, supplier_items|
      if supplier_id.present?
        supplier = Spree::Supplier.find(supplier_id)
        dso = supplier.orders.create({:order_id => self.id}, without_protection: true)
        supplier_items.each do |line_item|
          dso.drop_ship_line_items.create({line_item_id: line_item.id}, without_protection: true)
        end
      end
    end
  end

end
