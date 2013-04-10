class CreateDropShipOrders < ActiveRecord::Migration

  def change
    create_table :spree_drop_ship_orders do |t|
      t.references :order
      t.references :supplier
      t.float      :total
      t.decimal    :commission, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.text       :notes
      t.datetime   :sent_at
      t.datetime   :confirmed_at
      t.datetime   :completed_at
      t.string     :state, :default => "active"
      t.timestamps
    end
    add_index :spree_drop_ship_orders, :order_id
    add_index :spree_drop_ship_orders, :supplier_id
    add_index :spree_drop_ship_orders, :completed_at
    add_index :spree_drop_ship_orders, :confirmed_at
    add_index :spree_drop_ship_orders, :sent_at
  end

end
