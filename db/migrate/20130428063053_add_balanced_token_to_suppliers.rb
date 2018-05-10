class AddBalancedTokenToSuppliers < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_suppliers, :tax_id, :string
    add_column :spree_suppliers, :token, :string
    add_index :spree_suppliers, :token
  end
end
