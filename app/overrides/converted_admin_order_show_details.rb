Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "converted_admin_order_show_details",
                     :insert_after => "[data-hook='admin_order_show_details'], #admin_order_show_details[data-hook]",
                     :partial => "spree/admin/orders/drop_ship_info",
                     :disabled => false)
