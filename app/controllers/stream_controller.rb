class StreamController < CatalogAbstractController
  def index
    @activity_items = Item.for_stream(current_user, params)
  end

  def following
    @boutiques = current_user.boutiques_following.includes({ locations: :address })
  end
end
