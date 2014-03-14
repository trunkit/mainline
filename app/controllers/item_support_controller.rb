class ItemSupportController < ApplicationController
  def create
    Item.find(params[:item_id]).support(current_user.parent)
    redirect_to(stream_path)
  end

  def destroy
    item = Item.includes(:children).find(params[:item_id])
    item.children.detect{|i| i.boutique == current_user.parent }.try(:destroy)
    redirect_to(stream_path)
  end
end
