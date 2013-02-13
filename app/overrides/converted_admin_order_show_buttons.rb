Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "converted_admin_order_show_buttons",
                     :insert_after => "code[erb-silent]:contains('content_for :page_actions do')",
                     :partial => "spree/admin/orders/confirm_drop_ship_info",
                     :disabled => false)
