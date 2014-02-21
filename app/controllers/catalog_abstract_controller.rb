class CatalogAbstractController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    redirect_to(:admin) if current_user.has_any_role?(:system)
  end

  helper_method :current_cart, :current_order, :categories

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

  def current_order
    return @current_order if @current_order

    if session[:order_id]
      @current_order = current_user.orders.find(session[:order_id])
    else
      @current_order     = current_user.orders.create(cart_id: current_cart.id)
      session[:order_id] = @current_order.id
    end

    @current_order
  end

  def categories
    @categories ||= Category.all
  end
end
