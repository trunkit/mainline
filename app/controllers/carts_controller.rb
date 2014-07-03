class CartsController < CatalogAbstractController
  def show
    @changes = current_cart.verify_quantities!
    current_cart.verify_latest_data!(true)
    current_cart.items(true)
  end
end
