Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :drop_ship_orders, only: [:edit, :index, :update] do
      member do
        put :confirm
        put :deliver
      end
    end
    resource :drop_ship_settings
    resources :suppliers
  end

  namespace :api, :defaults => { :format => 'json' } do
    resources :drop_ship_orders do
      resources :return_authorizations
      resources :shipments, :only => [:create, :update] do
        member do
          put :ship
          # TODO eventually let them cancel with remove?
          # put :remove
        end
      end
    end
  end

  resources :suppliers, only: [:create, :new]

end
