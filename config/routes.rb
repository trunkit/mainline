Trunkit::Application.routes.draw do
  root to: "contents#index"

  # User / Session Management
  resource :session, only: [:new, :create, :destroy]

  get "logout" => "sessions#destroy"

  scope ":user_type" do
    resource :user, only: [:create] do
      get "twitter",  on: :new
      get "facebook", on: :new
    end
  end

  # Catalog
  get "stream"           => "stream#index",     as: :stream
  get "stream/following" => "stream#following", as: :stream_following
  get "favorites"        => "favorites#index",  as: :favorites

  resources :items

  resources :boutiques

  # Product discovery
  get "discover" => redirect("/discover/boutiques"), as: :discover

  namespace :discover do
    resources :boutiques, only: [:index]
    resources :items,     only: [:index]
  end

  # Checkout and Shopping Cart
  resource :cart

  namespace :checkout do
    resources :shipping_addresses
    resource  :delivery_options
    resources :payment_methods
    resource  :order
  end

  # Administrative Interfaces
  namespace :admin do
    resources :brands, :boutiques do
      resources :items
    end

    resources :items, :orders, :users
  end

  # Catch-all, generic routing
  get "*path" => "contents#show"
end
