Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "converted_admin_order_show_buttons",
                     :insert_top => "[data-hook='admin_order_show_buttons'], #admin_order_show_buttons[data-hook]",
                     :partial => "spree/admin/orders/confirm_drop_ship_info",
                     :disabled => false)
