class StreamController < CatalogAbstractController
  def index
    @items = Item.all
  end

	def following
		@boutiques = Boutique.includes(:top_items, { locations: :address })
	end
end
