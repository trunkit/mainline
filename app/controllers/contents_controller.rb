class ContentsController < ApplicationController
  def index
    if current_user
      current_user.has_role?(:system) ?
        redirect_to(:admin) :
        redirect_to(items_path(supported: false))
    else
      @boutiques = Boutique.order(name: :asc)
    end
  end

  def show
    path = request.path[1,request.path.length-1]
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}")
  end
end
