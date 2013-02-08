Deface::Override.new(:virtual_path => "spree/products/_properties",
                     :name => "product_properties_insert_supplier_info",
                     :insert_bottom => "table#product-properties tbody",
                     :partial => "spree/products/supplier_info",
                     :disabled => false)
