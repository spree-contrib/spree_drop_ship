module Dropship
  module Spree
    module PaymentDecorator
      def self.prepended(base)
        base.belongs_to :payable, polymorphic: true, optional: true
      end
    end
  end
end

Spree::Payment.prepend Dropship::Spree::PaymentDecorator
