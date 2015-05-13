module Spree
  Variant.class_eval do

    has_many :suppliers, through: :supplier_variants
    has_many :supplier_variants

    before_create :populate_for_suppliers

    private

    durably_decorate :create_stock_items, mode: 'soft', sha: '98704433ac5c66ba46e02699f3cf03d13d4f1281' do
      StockLocation.all.each do |stock_location|
        if stock_location.supplier_id.blank? || self.suppliers.pluck(:id).include?(stock_location.supplier_id)
          stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
        end
      end
    end

    def populate_for_suppliers
      self.suppliers = self.product.suppliers
    end

  end
end
