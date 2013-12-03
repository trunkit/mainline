class ContentsController < ApplicationController
  def index
    if current_user
      redirect_to(stream_path)
    else
      @items = referring_boutique ? referring_boutique.items : Item
      @items = @items.order('updated_at').limit(18)

      render(action: :index)
    end
  end

  def show
    path = request.path[1,request.path.length-1]
    path = path.downcase.gsub(/[^A-Za-z0-9\/]+/, '_')

    render(template: "contents/#{path}")
  end
end
