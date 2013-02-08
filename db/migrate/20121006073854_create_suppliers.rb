class CreateSuppliers < ActiveRecord::Migration

  def change
    create_table :spree_suppliers do |t|
      t.references :user
      t.references :address
      t.string     :name
      t.string     :email
      t.string     :phone
      t.string     :url
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :spree_suppliers, :user_id
    add_index :spree_suppliers, :address_id
    add_index :spree_suppliers, :deleted_at
  end

end
