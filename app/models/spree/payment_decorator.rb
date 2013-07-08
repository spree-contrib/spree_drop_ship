module Spree
  Payment.class_eval do

    belongs_to :shipment

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

      if shipment
        Rails.logger.debug 'GatewayShipment'
        Rails.logger.debug shipment.inspect
        Rails.logger.debug shipment.ship_total.to_f.inspect
        Rails.logger.debug shipment.tax_total.to_f.inspect
        Rails.logger.debug shipment.item_total.to_f.inspect
        Rails.logger.debug shipment.promo_total.to_f.inspect
        options.merge!({ :shipping => shipment.cost * 100,
                         # :tax      => shipment.tax_total * 100, # needs to be line item adjustments
                         :subtotal => shipment.item_cost * 100,
                         # :discount => shipment.promo_total * 100, # needs to be line item adjustments
                         :currency => currency })
      else
        Rails.logger.debug 'GatewayMarket'
        # todo have this run after all shipment payments and just collect balance due?
        options.merge!({ :shipping => order.ship_total * 100,
                         :tax      => order.tax_total * 100,
                         :subtotal => order.item_total * 100,
                         :discount => order.promo_total * 100,
                         :currency => currency })
      end

      options.merge!({ :billing_address  => order.bill_address.try(:active_merchant_hash),
                      :shipping_address => order.ship_address.try(:active_merchant_hash) })
                      Rails.logger.debug 'GatewayResults'
                      Rails.logger.debug options.inspect
                      Rails.logger.debug options[:shipping].to_f.inspect
                      Rails.logger.debug options[:tax].to_f.inspect
                      Rails.logger.debug options[:subtotal].to_f.inspect
                      Rails.logger.debug options[:discount].to_f.inspect

      options
    end

  end
end
