class AddSupplierToLineItems < ActiveRecord::Migration

  def change
    add_column :spree_line_items, :supplier_id, :integer
  end

end
