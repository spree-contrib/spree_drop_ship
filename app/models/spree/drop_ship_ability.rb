class Spree::DropShipAbility

  include CanCan::Ability

  def initialize(user)
    can [:read, :update], Spree::DropShipOrder do |order|
      order.user && order.user == user
    end
  end
end

Spree::Ability.register_ability(Spree::DropShipAbility)
