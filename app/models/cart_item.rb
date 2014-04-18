class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, presence: true
  validates :item_id, :item_version, :cart_id, numericality: true

  def item
    return @item if @item

    @item = Item.find(item_id)

    if @item.version > item_version
      @item = @item.versions[item_version].reify
    end

    @item
  end

  def unit_price
    item.price
  end

  def total_price
    quantity * unit_price
  end
end
