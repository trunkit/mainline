class Admin::LocationsController < Admin::AbstractController
	helper_method :boutique

	def new
		@location = boutique.locations.build
	end

	def create
		@location = boutique.locations.build(location_params)

		if @location.save
			redirect_to([:edit, :admin, boutique, @location])
		else
			render(action: :new)
		end
	end

	def edit
		@location = boutique.locations.find(params[:id])
	end

	def update
		@location = boutique.locations.find(params[:id])

		if @location.update_attributes(location_params)
			redirect_to([:edit, :admin, boutique, @location])
		else
			render(action: :edit)
		end
	end

	def destroy
		boutique.locations.find(params[:id]).destroy
		redirect_to([:edit, :admin, boutique])
	end

private

	def location_params
		params.require(:location).permit(:name, :cover_photo, :stream_photo, address_attributes: [:id, :street, :street2, :city, :state, :postal_code])
	end

	def boutique
		@boutique ||= Boutique.find(params[:boutique_id])
	end
end
