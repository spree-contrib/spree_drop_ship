class CreateDropShipLineItems < ActiveRecord::Migration

  def change
    create_table :spree_drop_ship_line_items do |t|
      t.references :drop_ship_order
      t.references :line_item
      t.timestamps
    end
    add_index :spree_drop_ship_line_items, :drop_ship_order_id
    add_index :spree_drop_ship_line_items, :line_item_id
  end

end
