Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                     :name => "converted_admin_orders_index_headers",
                     :insert_bottom => "[data-hook='admin_orders_index_headers'], #admin_orders_index_headers[data-hook]",
                     :partial => "spree/admin/orders/dso_order_header",
                     :disabled => false)
