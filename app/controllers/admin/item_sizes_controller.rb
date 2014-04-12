class Admin::ItemSizesController < ApplicationController
  before_filter do
    @item = Item.find(params[:item_id])
  end

  def create
    @item.add_or_update_size(params[:size], params[:quantity])
    redirect_to([:edit, :admin, @item])
  end

  def update
    @item.add_or_update_size(params[:size], params[:quantity])
    redirect_to([:edit, :admin, @item])
  end

  def destroy
    @item.remove_size(params[:id])
    redirect_to([:edit, :admin, @item])
  end
end
