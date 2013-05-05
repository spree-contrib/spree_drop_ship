module Spree
  Gateway::BalancedGateway.class_eval do
    def capture(authorization, creditcard, gateway_options)
      Rails.logger.debug 'BALANCEDCAPTURE'
      Rails.logger.debug authorization.inspect
      Rails.logger.debug (authorization.amount * 100).round
      Rails.logger.debug self.supplier.token if self.supplier.present?
      Rails.logger.debug self.preferrred_on_behalf_of_uri
      if authorization.shipment.supplier.present?
        gateway_options[:on_behalf_of_uri] = authorization.shipment.supplier.token
      else
        gateway_options[:on_behalf_of_uri] = self.preferred_on_behalf_of_uri
      end
      Rails.logger.debug gateway_options[:on_behalf_of_uri]
      provider.capture((authorization.amount * 100).round, authorization.response_code, gateway_options)
    end
  end
end
