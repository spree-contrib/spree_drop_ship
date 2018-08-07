module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier, optional: true
    belongs_to :variant, optional: true
  end
end
