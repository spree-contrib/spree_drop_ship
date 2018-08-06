module Dropship
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.belongs_to :supplier, class_name: 'Spree::Supplier', optional: true

        base.has_many :variants, through: :supplier
      end

      def supplier?
        supplier.present?
      end
    end
  end
end

Spree.user_class.prepend Dropship::Spree::UserDecorator
