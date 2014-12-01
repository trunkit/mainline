Trunkit::Application.routes.draw do
  get 'learn_more/learn_trunkit'

  get 'learn_more/learn_trunksale'

  get 'learntrunksale/learntrunksale'

  get 'learn_trunkit/learn_trunkit'

  root to: "contents#index"

  # Catalog
  get "stream"                    => "stream#index",     as: :stream
  get "stream/following"          => "stream#following", as: :stream_following
  get "stream/category/:category" => "stream#index",     as: :stream_category

  resources :favorites, only: [:index, :create]

  resources :items do
    put 'support',   on: :member
    put 'unsupport', on: :member

    resources :declinations, only: [:index, :update], controller: "item_declinations"
    resources :notifications, only: [:create], controller: "item_notifications"

    resources :photos, controller: "item_photos" do
      put "reorder", on: :collection
    end
  end

  resources :brands, only: [:index, :create]
  resources :categories, only: [:index]
  resources :categories, only: [:index]

  resources :boutiques, :brands, only: [:show] do
    get 'search',   on: :collection
    put 'follow',   on: :member
    put 'unfollow', on: :member
  end

  # Product discovery
  resource :discover, controller: 'discover' do
    get 'q' => 'discover#create', as: :search
  end

  # Checkout and Shopping Cart
  resource :cart do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  namespace :checkout do
    resources :shipping_addresses do
      put "select", on: :member
    end

    resource :delivery_options, :payment_method, :order
  end

  # User information
  resource  :user, only: [:update] do
    get "settings"
  end

  resources :addresses

  # Boutique Management Interfaces
  resources :notifications, :customer_orders, only: [:index]
  resources :customer_orders
  

  scope("order_items/:id", as: :order_item) do
    resource :cancellation, only: [:new, :create], controller: "order_item_cancellations"
    put "complete" => "order_items#complete", as: :complete
  end

  # Boutique Transfers management
  namespace :payments do
    resource  :company, controller: "company"
  end

  # Session Management
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # Administrative Interfaces
  resources :shipping_events, only: [:create]

  namespace :admin do
    resources :boutiques
    resources :brands, :categories, :customer_orders

    resources :items do
      put :approve, :unapprove, on: :member
      get :pending_approval,    on: :collection

      resources :sizes,  controller: "item_sizes"
      resources :photos, controller: "item_photos"
    end

    resources :users, except: [:show] do
      post "welcome"    => "users#welcome"
      put  "masquerade" => "users#masquerade"
    end
  end

  get "admin" => redirect("/admin/customer_orders")

  post "boutique_sign_up" => "boutique_sign_up#create"

  # Catch-all, generic routing
  get "*path" => "contents#show"
end
