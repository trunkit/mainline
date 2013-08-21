class UsersController < ApplicationController
  layout "home"

  def new
    render(template: "users/new_#{params[:user_type]}")
  end
end
