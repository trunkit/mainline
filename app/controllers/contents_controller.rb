class ContentsController < ApplicationController
  def index
    redirect_to(stream_path) if current_user

    render(action: :index, layout: "home")
  end

  def show
    path = request.path[1,request.path.length-1]
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}", layout: (current_user ? "application" : "home"))
  end
end
