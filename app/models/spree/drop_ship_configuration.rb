module Spree
  class DropShipConfiguration < Preferences::Configuration

    # Allow users to signup as a supplier.
    preference :allow_signup, :boolean, default: false

    # Automatically deliver drop ship orders by default.
    preference :automatically_deliver_orders_to_supplier, :boolean, default: true

    # Sets Balanced Payments api configuration.
    preference :balanced_api_key, :string, default: -> {
      if ActiveRecord::Base.connection.table_exists?(:spree_payment_methods)
        # If you are using Balanced Payments as a credit card processor we automatically lookup your api key to use for payments.
        Spree::PaymentMethod.where(type: 'Spree::Gateway::BalancedGateway', environment: Rails.env).first.try(:preferred_login)
      end
    }.call

    # Default flat rate to charge drop ship suppliers per order for commission.
    preference :default_commission_flat_rate, :float, default: 0.0

    # Default percentage to charge drop ship suppliers per order for commission.
    preference :default_commission_percentage, :float, default: 0.0

    # Determines whether or not to email a new supplier their welcome email.
    preference :send_supplier_email, :boolean, default: true

  end
end
