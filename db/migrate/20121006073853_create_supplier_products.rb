class CreateSupplierProducts < ActiveRecord::Migration

  def change
    create_table :spree_supplier_products do |t|
      t.references :supplier
      t.references :product
    end
  end

end
