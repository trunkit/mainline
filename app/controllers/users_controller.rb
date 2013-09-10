class UsersController < ApplicationController
  layout "home"

  def create
    @user      = User.new(user_params)
    @user.role = params[:user_type]

    session["user_id"] = @user.id if @user.save

    respond_to do |format|
      format.js do
        if !session["user_id"].present?
          flash[:errors] = @user.errors
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
