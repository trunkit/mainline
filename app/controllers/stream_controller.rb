class StreamController < CatalogAbstractController
  def index
    @activity_items = Item.for_stream(current_user, params)

    if params[:category]
      @category      = Category.find(params[:category].to_i)
      @category      = @category.parent unless @category.root?
      @subcategories = @category.children
    end
  end

  def following
    @boutiques = current_user.boutiques_following.includes({ location: :address })
  end
end
