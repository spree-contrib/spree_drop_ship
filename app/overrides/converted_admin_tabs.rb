Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "converted_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :partial => "spree/admin/shared/suppliers_tab",
                     :disabled => false)
