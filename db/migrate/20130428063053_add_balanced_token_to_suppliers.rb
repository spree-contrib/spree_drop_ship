class AddBalancedTokenToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :contacts_date_of_birth, :datetime
    add_column :spree_suppliers, :merchant_type, :string
    add_column :spree_suppliers, :tax_id, :string
    add_column :spree_suppliers, :token, :string
    add_index :spree_suppliers, :token
  end
end
