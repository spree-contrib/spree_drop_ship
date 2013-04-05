module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new
      if user.supplier
        puts "SupplierAbility: #{user.inspect} - #{user.supplier.inspect}"
        can [:admin, :edit, :index, :read, :show, :update], Spree::DropShipOrder, supplier_id: user.supplier_id
        can [:admin, :create, :edit, :index, :new, :update], Spree::Product, supplier_id: user.supplier_id
        can [:admin, :create, :edit, :index, :new, :update], Spree::Shipment, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :create, :edit, :index, :new, :update], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :create, :edit, :index, :new, :update], Spree::Supplier, id: user.supplier_id
      else
        # TODO Add preference to allow signups or not.
        can [:create, :new], Spree::Supplier
      end
    end
  end
end
Spree::Ability.register_ability(Spree::SupplierAbility)
