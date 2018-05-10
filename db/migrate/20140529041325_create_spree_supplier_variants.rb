class CreateSpreeSupplierVariants < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_supplier_variants do |t|
      t.belongs_to :supplier, index: true
      t.belongs_to :variant, index: true
      t.decimal :cost

      t.timestamps
    end
    Spree::Product.where.not(supplier_id: nil).each do |product|
      product.add_supplier! product.supplier_id
    end
    remove_column :spree_products, :supplier_id
  end
end
