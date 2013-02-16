Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                     :name => "converted_admin_order_tabs",
                     :insert_bottom => "[data-hook='admin_order_tabs'], #admin_order_tabs[data-hook]",
                     :partial => "spree/admin/orders/drop_ship_order_sidebar_tab",
                     :disabled => false)
