class StreamController < CatalogAbstractController
  def index
    @items = Item.all
  end

	def following
		@boutiques = Boutique.includes({ locations: :address })
	end
end
