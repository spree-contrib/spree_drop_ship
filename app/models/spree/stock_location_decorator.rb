Spree::StockLocation.class_eval do

  belongs_to :supplier
  attr_accessible :supplier_id

  scope :with_supplier, ->(supplier) { where(supplier_id: supplier) }

  # Wrapper for creating a new stock item respecting the backorderable config and supplier
  # def propagate_variant(variant)
  #   self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
  #   if self.supplier_id.nil? or self.supplier_id == variant.product.supplier_id
  #     # puts 'yay'
  #     # item = self.stock_items.build(variant: variant, backorderable: self.backorderable_default)
  #     # puts item.inspect
  #     # item.save
  #     # puts 'after create'
  #     self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
  #   else
  #     puts 'else'
  #     # Never allow alternate suppliers locations to take backorders for a product.
  #     self.stock_items.create!(variant: variant, backorderable: false)
  #   end
  # end

end
