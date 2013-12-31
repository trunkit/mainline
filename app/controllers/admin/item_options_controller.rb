module Admin
  class ItemOptionsController < ::Admin::AbstractController
    before_filter do
      @item = Item.find(params[:item_id])
    end

    def create
      if @option = @item.options.create(option_params)
        redirect_to([:edit, :admin, @item])
      else
        render(template: "admin/items/edit")
      end
    end

    def update
      @option = @item.options.find(params[:id])

      if @option.update_attributes(option_params)
        redirect_to([:edit, :admin, @item])
      else
        render(template: "admin/items/edit")
      end
    end

    def destroy
      @item.options.find(params[:id]).destroy
      redirect_to([:edit, :admin, @item])
    end

  private
    def option_params
      params.require(:item_option).permit(:name, :value, :price)
    end
  end
end
