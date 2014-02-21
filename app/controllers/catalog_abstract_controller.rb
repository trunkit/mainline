class CatalogAbstractController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    redirect_to(:admin) if current_user.has_any_role?(:system)
  end

  helper_method :current_cart, :categories

  private

  def current_cart
    return @current_cart if @current_cart

    if session[:cart_id]
      @current_cart = current_user.carts.find(session[:cart_id])
    else
      @current_cart     = current_user.carts.create
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end

  def categories
    @categories ||= Category.all
  end
end
