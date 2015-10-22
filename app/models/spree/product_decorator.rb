Spree::Product.class_eval do

  has_many :suppliers, through: :master

  def add_supplier!(supplier_or_id)
    supplier = supplier_or_id.is_a?(Spree::Supplier) ? supplier_or_id : Spree::Supplier.find(supplier_or_id)
    populate_for_supplier! supplier if supplier
  end

  def add_suppliers!(supplier_ids)
    Spree::Supplier.where(id: supplier_ids).each do |supplier|
      populate_for_supplier! supplier
    end
  end

  # Returns true if the product has a drop shipping supplier.
  def supplier?
    suppliers.present?
  end

  private

  def populate_for_supplier!(supplier)
    variants_including_master.each do |variant|
      unless variant.suppliers.pluck(:id).include?(supplier.id)
        variant.suppliers << supplier
        supplier.stock_locations.each { |location| location.set_up_stock_item(variant) }
      end
    end
  end

end
