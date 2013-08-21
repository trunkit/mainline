class CatalogAbstractController < ApplicationController
  private

  before_filter :check_user_state

  def check_user_state
    redirect_to(root_path) unless current_user
  end
end
