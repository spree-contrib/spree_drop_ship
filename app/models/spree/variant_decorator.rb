module Spree
  Variant.class_eval do

    delegate :supplier, :supplier_id, to: :product

    private

    durably_decorate :create_stock_items, mode: 'soft', sha: '4f82bc9c291bbef359b490e622b2b2c58d9691ee' do
      if self.supplier_id.present?
        StockLocation.by_supplier(self.supplier_id).each do |stock_location|
          stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
        end
      else
        StockLocation.all.each do |stock_location|
          stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
        end
      end
    end

  end
end
