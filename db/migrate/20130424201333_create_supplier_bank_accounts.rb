class CreateSupplierBankAccounts < ActiveRecord::Migration
  def change
    create_table :spree_supplier_bank_accounts do |t|
      t.string :masked_number
      t.belongs_to :supplier
      t.string :token
      t.boolean :verified, default: false, null: false
      t.string :verification_token
      t.timestamps
    end
    add_index :spree_supplier_bank_accounts, :supplier_id
    add_index :spree_supplier_bank_accounts, :token
    add_index :spree_supplier_bank_accounts, :verified
    add_index :spree_supplier_bank_accounts, :verification_token
  end
end
