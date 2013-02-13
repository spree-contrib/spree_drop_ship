class UpdateSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_drop_ship_line_items, :line_item_id, :integer
    add_column :spree_drop_ship_orders, :commission_fee, :decimal, :precision => 8, :scale => 2, :default => 0.0, :null => false
    add_column :spree_suppliers, :commission_fee_percentage, :float, default: 0
  end
end
