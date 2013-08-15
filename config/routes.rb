Trunkit::Application.routes.draw do
  root to: "contents#index"

  # Checkout and Shopping Cart
  resource :cart

  namespace :checkout do
    resources :shipping_addresses
    resource  :delivery_options
    resources :payment_methods
    resource  :order
  end

  # Catch-all, generic routing
  get "*path" => "contents#show"
end
