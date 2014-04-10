class ContentsController < ApplicationController
  def index
    if current_user
      current_user.has_role?(:system) ?
        redirect_to(:admin) :
        redirect_to(stream_path)
    else
      @activity_items = referring_boutique ?
        Item.for_stream(nil, { boutique_id: [referring_boutique.id] }) :
        Item.for_stream(nil, {})

      render(action: :index)
    end
  end

  def show
    path = request.path[1,request.path.length-1]
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}")
  end
end
