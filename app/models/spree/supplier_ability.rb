module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new
      Rails.logger.debug "SupplierAbility: #{user.inspect} - #{user.supplier.inspect}"
      if user.supplier
        Rails.logger.debug "SupplierAbility: #{user.inspect} - #{user.supplier.inspect}"
        can [:admin, :edit, :index, :read, :show, :update], Spree::DropShipOrder, :supplier_id => user.supplier.id
        can [:admin, :create, :edit, :index, :new, :update], Spree::Product, :supplier_id => user.supplier.id
      end
    end
  end
end
Spree::Ability.register_ability(Spree::SupplierAbility)
