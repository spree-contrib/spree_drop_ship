Spree::Order.class_eval do

  has_many :drop_ship_orders

  def approve_drop_ship_orders
    drop_ship_orders.select{ |dso| dso.deliver }.length == drop_ship_orders.length
  end

  def finalize_with_dropship!
    finalize_without_dropship!

    self.line_items.will_drop_ship.all.group_by{|li| li.supplier_id }.each do |supplier_id, supplier_items|
      supplier = Spree::Supplier.find(supplier_id)
      supplier.orders.create(:order => self).add(supplier_items) #.deliver!
    end
  end
  alias_method_chain :finalize!, :dropship

  def has_drop_ship_orders?
    drop_ship_orders.present?
  end

end
