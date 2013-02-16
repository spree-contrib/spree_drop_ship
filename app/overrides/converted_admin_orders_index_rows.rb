Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                     :name => "converted_admin_orders_index_rows",
                     :insert_bottom => "[data-hook='admin_orders_index_rows'], #admin_orders_index_rows[data-hook]",
                     :partial => "spree/admin/orders/drop_ship_order_order_row",
                     :disabled => false)
