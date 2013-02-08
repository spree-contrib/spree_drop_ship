Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "converted_admin_product_form_right",
                     :insert_bottom => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                     :partial => "spree/admin/shared/product_form_right",
                     :disabled => false)
