class UsersController < ApplicationController
  layout "home"

  def create
    @user      = User.new(user_params)
    @user.role = params[:user_type]

    if @user.save
      session["user_id"] = @user.id

      case @user.role
      when :shopper
        redirect_to(discover_path)
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
