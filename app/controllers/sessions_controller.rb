class SessionsController < ApplicationController
  layout "home"

  def new
    render(template: "sessions/new_#{params[:user_type]}")
  end

  def create
  end
end
