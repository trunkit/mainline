class SessionsController < ApplicationController
  layout "home"

  def new
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to(stream_path)
    else
      render(action: :new)
    end
  end

  def destroy
    session["user_id"] = nil
    redirect_to root_path
  end
end
