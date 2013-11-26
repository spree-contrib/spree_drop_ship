Spree::StockLocation.class_eval do

  belongs_to :supplier

#  Spree::PermittedAttributes.stock_location_attributes << :supplier_id

  scope :with_supplier, ->(supplier) { where(supplier_id: supplier) }

  # Wrapper for creating a new stock item respecting the backorderable config and supplier
  durably_decorate :propagate_variant, mode: 'soft', sha: 'f35b0d8a811311d4886d53024a9aa34e3aa5f8cb' do |variant|
    if self.supplier_id.nil? or self.supplier_id == variant.product.try(:supplier_id)
      self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
    else
      # Never allow alternate suppliers locations to take backorders for a product.
      # TODO: consider removing creating a stock item at all... issue could be multiple sellers wanting to sell the same product,
      #       but if we solve multiple supplier problem by just creating a variant for each supplier we're all set to remove.
      self.stock_items.create!(variant: variant, backorderable: false)
    end
  end

end
