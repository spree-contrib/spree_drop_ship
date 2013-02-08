class CreateDropShipLineItems < ActiveRecord::Migration

  def change
    create_table :spree_drop_ship_line_items do |t|
      t.references :drop_ship_order
      t.integer    :variant_id
      t.string     :sku
      t.string     :name
      t.integer    :quantity, :default => 1
      t.decimal    :price, :precision => 8, :scale => 2, :null => false
      t.timestamps
    end
  end

end
