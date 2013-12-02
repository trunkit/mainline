class CatalogAbstractController < ApplicationController
  before_filter :authenticate_user!
end
