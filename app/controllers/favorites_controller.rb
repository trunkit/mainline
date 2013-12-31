class FavoritesController < ApplicationController
	def index
		@items = Item.all
	end
end
