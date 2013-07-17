module Spree
  Payment.class_eval do

    belongs_to :drop_ship_order

    # Overridding gateway_options to submit drop ship order amounts when applicable.
    def gateway_options
      options = { :email    => order.email,
                  :customer => order.email,
                  :ip       => order.last_ip_address,
                  # Need to pass in a unique identifier here to make some
                  # payment gateways happy.
                  #
                  # For more information, please see Spree::Payment#set_unique_identifier
                  :order_id => gateway_order_id }

      if drop_ship_order
        options.merge!({ :shipping => drop_ship_order.ship_total * 100,
                         :tax      => drop_ship_order.tax_total * 100, # TODO needs to be line item adjustments
                         :subtotal => drop_ship_order.item_total * 100,
                         :discount => drop_ship_order.promo_total * 100, # TODO needs to be line item adjustments
                         :currency => currency })
      else
        # todo have this run after all shipment payments and just collect balance due?
        options.merge!({ :shipping => order.ship_total * 100,
                         :tax      => order.tax_total * 100,
                         :subtotal => order.item_total * 100,
                         :discount => order.promo_total * 100,
                         :currency => currency })
      end

      options.merge!({ :billing_address  => order.bill_address.try(:active_merchant_hash),
                      :shipping_address => order.ship_address.try(:active_merchant_hash) })

      options
    end

  end
end
