module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier
        can [:admin, :confirm, :deliver, :index, :read, :update], Spree::DropShipOrder, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::Image, viewable: { product: { supplier_id: user.supplier_id } }
        can :create, Spree::Image
        if defined?(Spree::GroupPrice)
          can [:admin, :manage], Spree::GroupPrice, variant: { product: { supplier_id: user.supplier_id } }
        end
        if defined?(Spree::Relation)
          can [:admin, :manage], Spree::Relation, relatable: { supplier_id: user.supplier_id }
        end
        can [:admin, :manage, :stock], Spree::Product, supplier_id: user.supplier_id
        can :create, Spree::Product
        can [:admin, :manage], Spree::ProductProperty, product: { supplier_id: user.supplier_id }
        can [:admin, :index, :read], Spree::Property
        can [:admin, :read], Spree::Prototype
        can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :manage], Spree::StockItem, variant: { product: { supplier_id: user.supplier_id } } 
        can [:admin, :manage], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::StockMovement, stock_item: { variant: { product: { supplier_id: user.supplier_id } } }
        can [:admin, :update], Spree::Supplier, id: user.supplier_id
        can [:admin, :manage], Spree::SupplierBankAccount, supplier_id: user.supplier_id
        can :create, Spree::SupplierBankAccount
        can [:admin, :manage], Spree::Variant, product: { supplier_id: user.supplier_id }
      end

      if Spree::DropShipConfig[:allow_signup]
        can :create, Spree::Supplier
      end
    end
  end
end
