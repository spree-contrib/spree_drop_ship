class AddShipmentIdToPayments < ActiveRecord::Migration
  def change
    add_column :spree_payments, :shipment_id, :integer
    add_index :spree_payments, :shipment_id
  end
end
