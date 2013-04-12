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

  resources :suppliers, only: [:create, :new]

end
