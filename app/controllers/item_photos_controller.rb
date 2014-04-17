class ItemPhotosController < ApplicationController
  before_filter do
    @item = current_user.items.find(params[:item_id])
  end

  def create
    params[:photo][:url].each do |file|
      @item.photos.create(url: file)
    end
  end

  def destroy
    @item.photos.find(params[:id]).destroy
    render("create")
  end
end
