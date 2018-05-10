module Dropship
  module Spree
    module StockLocationDecorator
      def self.prepended(base)
        base.belongs_to :supplier, class_name: 'Spree::Supplier'

        base.scope :by_supplier, ->(supplier_id) { where(supplier_id: supplier_id) }
      end

      # Wrapper for creating a new stock item respecting the backorderable config and supplier
      def propagate_variant(variant)
        if supplier_id.blank? || variant.suppliers.pluck(:id).include?(supplier_id)
          stock_items.create!(variant: variant, backorderable: backorderable_default)
        end
      end

      def available?(variant)
        stock_item(variant).try(:available?)
      end
    end
  end
end

Spree::StockLocation.prepend Dropship::Spree::StockLocationDecorator
