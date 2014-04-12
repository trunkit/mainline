Trunkit::Application.routes.draw do
  root to: "contents#index"

  # Catalog
  get "stream"           => "stream#index",     as: :stream
  get "stream/following" => "stream#following", as: :stream_following

  resources :favorites, only: [:index, :create]

  resources :items do
    put 'support',   on: :member
    put 'unsupport', on: :member
  end

  resources :boutiques, :brands, only: [:show] do
    put 'follow',   on: :member
    put 'unfollow', on: :member
  end

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

    resources :brands, :categories, :orders

    resources :items do
      put :approve, :unapprove, on: :member
      get :pending_approval,    on: :collection

      resources :sizes,  controller: "item_sizes"
      resources :photos, controller: "item_photos"
    end

    resources :users, except: [:new, :show] do
      put "masquerade" => "users#masquerade"
    end
  end

  get "admin" => "admin/dashboards#index"

  # Catch-all, generic routing
  get "*path" => "contents#show"
end
