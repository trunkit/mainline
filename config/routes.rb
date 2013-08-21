Trunkit::Application.routes.draw do
  root to: "contents#index"

  scope ":user_type" do
    # User / Session Management
    resource :session

    resource :user, only: [:new, :create] do
      get "twitter",  on: :new
      get "facebook", on: :new

      member do
        get  "categories" => "user_categories#index", as: :categories
        post "categories" => "user_categories#create"

        get  "boutiques"  => "user_boutiques#index",  as: :boutiques
        post "boutiques"  => "user_boutiques#create"
      end
    end
  end

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
