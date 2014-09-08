class ItemPhotosController < ApplicationController
  before_filter do
    @item = current_user.items.find(params[:item_id])
  end

  def index
    respond_to do |format|
      format.json { render(json: @item.photos) }
    end
  end

  def create
    render(nothing: true, status: 200) if params[:photo].try(:[], :url).blank?

    params[:photo][:url].each do |file|
      @item.photos.create(url: file)
    end

    respond_to do |format|
      format.html
      format.json { render(json: @item.photos) }
    end
  end

  def reorder
    params[:photo_ids].each_with_index do |photo_id, i|
      @item.photos.find(photo_id).set_list_position(i + 1)
    end

    respond_to do |format|
      format.html { render("create") }
      format.json { render(json: @item.photos) }
    end
  end

  def destroy
    @item.photos.find(params[:id]).destroy

    respond_to do |format|
      format.html
      format.json { render(json: @item.photos) }
    end
  end
end
