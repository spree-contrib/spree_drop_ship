module Spree
  class DropShipConfiguration < Preferences::Configuration
    # Email to list as contact email for affiliate information.
    preference :affiliate_email, :string

    # Determines whether or not to email a new supplier their welcome email.
    preference :send_supplier_welcome_email, :boolean, :default => true
  end
end