class SessionsController < ApplicationController
  layout "home"

  def new
  end

  def create
  end

  def destroy
    session["user_id"] = nil
    redirect_to root_path
  end
end
