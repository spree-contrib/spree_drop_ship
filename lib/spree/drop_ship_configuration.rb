module Spree
  class DropShipConfiguration < Preferences::Configuration
    # Default percentage to charge drop ship suppliers per order for commission.
    preference :default_order_commission, :float, default: 0

    # Determines whether or not to email a new supplier their welcome email.
    preference :send_supplier_welcome_email, :boolean, default: true
  end
end
