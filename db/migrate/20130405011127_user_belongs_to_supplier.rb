class UserBelongsToSupplier < SpreeExtension::Migration[4.2]
  def change
    add_column Spree.user_class.table_name, :supplier_id, :integer
    add_index Spree.user_class.table_name, :supplier_id
  end
end
