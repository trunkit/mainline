class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, presence: true
  validates :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, numericality: true

  belongs_to :supporting_boutique, class_name: "Boutique"
  belongs_to :supplying_boutique, class_name: "Boutique"

  @@shipping_options = [['UPS Ground', 'Ground'], ['UPS 3 Day Select', '3DaySelect'], ['UPS Second Day Air', '2ndDayAir'], ['UPS Next Day Air Saver', 'NextDayAirSaver']].freeze
  cattr_reader :shipping_options

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

  def rate_for_service(service)
    shipment.rates.detect{|r| r.service == service }
  end

  def shipment
    return @shipment if @shipment

    @shipment = if shipment_id.blank?
      shipment = EasyPost::Shipment.create({
        to_address:   { id: cart.shipping_address.easypost_id },
        from_address: { id: item.boutique.location.easypost_id },
        parcel:       { id: item.parcel_id }
      })

      update_column(:shipment_id, shipment.id)

      shipment
    else
      EasyPost::Shipment.retrieve(shipment_id)
    end
  end
end
