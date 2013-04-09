Spree::Order.class_eval do

  has_many :drop_ship_orders

  def approve_drop_ship_orders
    drop_ship_orders.select{ |drop_ship_order| drop_ship_order.deliver }.length == drop_ship_orders.length
  end

  def finalize_with_dropship!
    finalize_without_dropship!

    self.line_items.group_by{ |li| li.product.supplier_id }.each do |supplier_id, supplier_items|
      if supplier_id.present?
        supplier = Spree::Supplier.find(supplier_id)
        # TODO: make delivering orders automatically a preference
        supplier.orders.create({:order_id => self.id}, without_protection: true).add(supplier_items) #.deliver!
      end
    end
  end
  alias_method_chain :finalize!, :dropship

  def has_drop_ship_orders?
    drop_ship_orders.present?
  end

end
