class RemoveDateOfBirth < ActiveRecord::Migration
  def change
    remove_column :spree_suppliers, :contacts_date_of_birth
    remove_column :spree_suppliers, :merchant_type
  end
end
