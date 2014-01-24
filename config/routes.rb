Trunkit::Application.routes.draw do
  root to: "contents#index"

  # User / Session Management
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # Catalog
  get "stream"           => "stream#index",     as: :stream
  get "stream/following" => "stream#following", as: :stream_following
  get "favorites"        => "favorites#index",  as: :favorites

  resources :items do
    put "favorite" => "items#favorite"
  end

  resources :boutiques, :brands, only: [:show]

  # Product discovery
  get "discover" => redirect("/discover/boutiques"), as: :discover

  namespace :discover do
    resources :boutiques, only: [:index]
    resources :items,     only: [:index]
  end

  # Checkout and Shopping Cart
  resource :cart do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  namespace :checkout do
    resources :shipping_addresses
    resource  :delivery_options
    resources :payment_methods
    resource  :order
  end

  # Administrative Interfaces
  namespace :admin do
    resources :boutiques do
      resources :locations
    end

    resources :brands, :orders

    resources :items do
      resources :item_options
      resources :photos,  controller: "item_photos"
    end

    resources :users, except: [:new, :show] do
      put "masquerade" => "users#masquerade"
    end
  end

  get "admin" => "admin/dashboards#index"

  # Catch-all, generic routing
  get "*path" => "contents#show"
end
