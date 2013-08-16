Trunkit::Application.routes.draw do
  root to: "contents#index"

  # User / Session Management
  get  "sign-in" => "sessions#new"
  post "sign-in" => "sessions#create"

  # Catalog
  get "stream" => "stream#index"

  resources :items

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
