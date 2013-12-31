class StreamController < CatalogAbstractController
  def index
    @items = Item.all
  end

	def following
		@boutiques = Boutique.joins(:top_items).includes({ locations: :address })
	end
end
