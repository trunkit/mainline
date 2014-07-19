class Admin::ItemPhotosController < ApplicationController
  def create
    item.photos.create(photo_params) if params[:photo].blank?
    redirect_to([:edit, :admin, item])
  end

  private

  def item
    @item ||= Item.find(params[:item_id])
  end

  def photo_params
    params.require(:photo).permit(:url)
  end
end
