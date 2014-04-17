module Spree
  Payment.class_eval do

    belongs_to :payable, polymorphic: true

  end
end
