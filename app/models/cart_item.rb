class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, presence: true
  validates :item_id, :item_version, :cart_id, numericality: true

  before_save :validate_item_options

  def item
    return @item if @item

    @item = Item.find(item_id)

    if @item.version > item_version
      @item = @item.versions[item_version].reify
    end

    @item
  end

  def option_values
    item_options.map{|group, id| item.options.find(id) }
  end

  def unit_price
    price = option_values.inject(item.price) {|price, option| price += option.price }
  end

  def total_price
    quantity * unit_price
  end

  private

  # TODO: Add item option validations
  def validate_item_options
  end
end
