Deface::Override.new(:virtual_path => "spree/users/show",
                     :name => "converted_account_summary",
                     :insert_after => "[data-hook='account_summary'], #account_summary[data-hook]",
                     :partial => "spree/users/drop_ship_orders",
                     :disabled => false)
