Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                     :name => "converted_admin_orders_index_headers",
                     :insert_bottom => "[data-hook='admin_orders_index_headers'], #admin_orders_index_headers[data-hook]",
                     :partial => "spree/admin/orders/drop_ship_order_order_header",
                     :disabled => false)
