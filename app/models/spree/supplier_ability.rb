module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier
        can [:admin, :index, :read, :update], Spree::DropShipOrder, supplier_id: user.supplier_id
        can [:admin, :manage, :stock], Spree::Product, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::Shipment, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :manage], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::Supplier, id: user.supplier_id
      end

      if Spree::DropShipConfig[:allow_signup]
        can :create, Spree::Supplier
      end
    end
  end
end
