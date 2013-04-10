Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :orders do
      member do
        get :approve_drop_ship
      end
    end
    resources :drop_ship_orders, only: [:edit, :index, :update] do
      member do
        get :deliver
      end
    end
    resource :drop_ship_settings
    resources :suppliers
  end

  resources :suppliers, only: [:create, :new]

end
