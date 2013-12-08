class CatalogAbstractController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    redirect_to(:admin) if current_user.has_any_role?(:system)
  end
end
