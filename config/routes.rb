Trunkit::Application.routes.draw do
  root to: "contents#index"

  # Catalog
  get "stream"           => "stream#index",     as: :stream
  get "stream/following" => "stream#following", as: :stream_following
  get "favorites"        => "favorites#index",  as: :favorites

  resources :items do
    put "favorite" => "items#favorite"
    resource :support, controller: "item_support"
  end

  resources :boutiques, :brands, only: [:show]

  # Product discovery
  resource :discover, controller: 'discover'

  # Checkout and Shopping Cart
  resource :cart do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  namespace :checkout do
    resources :shipping_addresses do
      patch "select", on: :member
    end

    resource  :delivery_options
    resources :payment_methods
    resource  :order
  end

  # User information
  resource  :user, only: [:update] do
    get "settings"
  end

  resources :addresses

  # Boutique Management Interfaces
  resources :orders, :notifications

  # Session Management
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

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
