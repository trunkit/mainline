module Admin
  class AbstractController < ApplicationController
    before_filter do
      redirect_to(stream_path) unless current_user.try(:has_role?, :system)
    end
  end
end