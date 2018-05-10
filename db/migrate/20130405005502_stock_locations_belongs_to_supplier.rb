class StockLocationsBelongsToSupplier < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_stock_locations, :supplier_id, :integer
    add_index :spree_stock_locations, :supplier_id
  end
end
