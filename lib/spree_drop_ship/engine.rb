module SpreeDropShip
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_drop_ship'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.spree_drop_ship.preferences", :after => "spree.environment" do |app|
      Spree::DropShipConfig = Spree::DropShipConfiguration.new
    end

    class DropShipAbility
      include CanCan::Ability

      def initialize(user)
        user ||= Spree.user_class.new
        can :read, Spree::DropShipOrder do |resource|
          resource.user && resource.user == user
        end
        can :update, Spree::DropShipOrder do |resource|
          resource.user && resource.user == user
        end
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Spree::Ability.register_ability(DropShipAbility)
    end

    config.to_prepare &method(:activate).to_proc
  end
end
