class Admin::OrdersController < Admin::AbstractController
  def index
    @orders = Cart.where.not(captured_at: nil).includes(:items).order(created_at: :desc)
    @users  = User.unscoped.where(id: @orders.map(&:user_id).uniq).index_by(&:id)
  end
end
