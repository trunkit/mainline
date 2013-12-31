class AbstractConsumerController < ApplicationController
	before_filter :require_user

private

	def require_user
		return if current_user

		respond_to do |format|
			format.html { redirect_to(root_path) }
			format.js   { render(nothing: true, status: 403) }
		end
	end
end
