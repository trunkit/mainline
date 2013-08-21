class CatalogAbstractController < ApplicationController
  private

  before_filter :check_user_state

  def check_user_state
    redirect_to(root_path) unless current_user
    redirect_to(categories_user_path(user_type: current_user.role)) unless current_user.ready?
  end
end
