class Admin::OrdersController < Admin::AbstractController
  def index
    @orders = Cart.where.not(captured_at: nil).includes(:items).order(created_at: :desc)
    @users  = User.unscoped.where(id: @orders.map(&:user_id).uniq).index_by(&:id)
  end

  def show
    @cart = Cart.includes(:items).find(params[:id])
    @user = User.unscoped.find(@cart.user_id)
  end
end
