module Dropship
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_many :stock_locations, through: :shipments
        base.has_many :suppliers, through: :stock_locations
      end

      # Once order is finalized we want to notify the suppliers of their drop ship orders.
      # Here we are handling notification by emailing the suppliers.
      # If you want to customize this you could override it as a hook for notifying a supplier with a API request instead.
      def finalize!
        super

        shipments.each do |shipment|
          next unless ::SpreeDropShip::Config[:send_supplier_email] && shipment.supplier.present?
          begin
            ::Spree::DropShipOrderMailer.supplier_order(shipment.id).deliver!
          rescue => ex # Errno::ECONNREFUSED => ex
            puts ex.message
            puts ex.backtrace.join("\n")
            Rails.logger.error ex.message
            Rails.logger.error ex.backtrace.join("\n")
            return true # always return true so that failed email doesn't crash app.
          end
        end
      end
    end
  end
end

Spree::Order.prepend Dropship::Spree::OrderDecorator
