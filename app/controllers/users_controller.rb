class UsersController < ApplicationController
  layout "home"

  def new
    @user = User.new(role: params[:user_type])
    render(template: "users/new_#{@user.role}")
  end

  def create
    @user      = User.new(user_params)
    @user.role = params[:user_type]

    if @user.save
      session["user_id"] = @user.id
      redirect_to(categories_user_path(user_type: @user.role))
    else
      render(template: "users/new_#{@user.role}")
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :gender, :role)
  end
end
