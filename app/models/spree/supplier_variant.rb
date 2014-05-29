module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant
  end
end
