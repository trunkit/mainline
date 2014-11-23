class StreamController < CatalogAbstractController
  swagger_controller :stream, "Product Stream"

  swagger_api :index do
    summary "Fetches all items in stream"
    notes "The return output is paginated"

    param :query, :category, :integer, :optional, "Category ID"
    param :query, :boutique_id, :integer, :optional, "Boutique ID"

    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity
  end

  def index
    @activity_items = Item.for_stream(current_user, params)

    if params[:category]
      @category      = Category.find(params[:category].to_i)
      @category      = @category.parent unless @category.root?
      @subcategories = @category.children
    end

    respond_to do |format|
      format.html
      format.json { render(json: @activity_items) }
    end
  end

  def following
    @boutiques = current_user.boutiques_following.includes(:address)
  end
end
