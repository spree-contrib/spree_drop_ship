Deface::Override.new(:virtual_path => "spree/users/show",
                    :name => "add_supplier_info",
                    :insert_bottom => '#user-info',
                    :partial => "spree/users/supplier_info",
                    :disabled => false)
