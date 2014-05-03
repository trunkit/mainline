class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, presence: true
  validates :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, numericality: true

  belongs_to :supporting_boutique, class_name: "Boutique"
  belongs_to :supplying_boutique, class_name: "Boutique"

  delegate :parcel, to: :item

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

  def shipment
    if shipment_id.blank?
      EasyPost::Shipment.create({
        to_address:   cart.shipping_address.easy_post,
        from_address: item.boutique.location.easy_post,
        parcel:       item.parcel
      })
    else
    end
  end
end
