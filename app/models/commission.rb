class Commission < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :boutique
  belongs_to :cart_item

  @@supplying_percentage = BigDecimal.new("0.82", 9)
  mattr_reader :supplying_percentage

  @@supporting_percentage = BigDecimal.new("0.10", 9)
  mattr_reader :supporting_percentage

  @@trunkit_percentage = BigDecimal.new("0.08", 9)
  mattr_reader :trunkit_percentage

  class << self
    def create_for_cart_item!(cart_item)
      cart_item = CartItem.find(cart_item) if cart_item.is_a?(Fixnum)
      raise ArgumentError, "cart item already has commissions!" if cart_item.commissions.size > 0

      transaction do
        cart_item.commissions.create!(extract_attrs(cart_item, :supplying))
        cart_item.commissions.create!(extract_attrs(cart_item, :supporting))

        if cart_item.cart.transaction_id.present?
          value = cart_item.subtotal_price_less_prorata_credit * trunkit_percentage
          cart_item.commissions.create!({ recipient_id: "self", value: value })
        end
      end

      true
    end

    def refund_for_cart_item!(cart_item)
      transaction do
        cart_item = CartItem.find(cart_item) if cart_item.is_a?(Fixnum)
        cart_item.commissions.where.not(boutique_id: nil).each(&:destroy)
      end

      true
    end

    def capture_for_boutiques!
      uncaptured = where(transfer_id: nil).where.not(boutique_id: nil).includes(:cart_item).lock.reject{|c| c.cart_item.refundable? }
      uncaptured.group_by(&:recipient_id).each {|recipient_id, commissions| capture!(recipient_id, commissions) }
      true
    end

    def capture_for_trunkit!
      uncaptured = where(transfer_id: nil, boutique_id: nil).includes(:cart_item)
      capture!("self", uncaptured) if uncaptured.present?
      true
    end

  private
    def capture!(recipient_id, commissions)
      transaction do
        begin
          transfer = Stripe::Transfer.create({
            amount:    (commissions.sum(&:value) * 100).to_i,
            currency:  "USD",
            recipient: recipient_id
          })

          commissions.each{|c| c.update_attributes(transfer_id: transfer.id) }

        rescue => e
          transfer.cancel
          raise e
        end
      end
    end

    def extract_attrs(cart_item, type)
      percentage = public_send("#{type.to_s}_percentage")
      boutique   = cart_item.send("#{type.to_s}_boutique")
      value      = cart_item.subtotal_price * percentage
      value      = value - cart_item.prorata_stripe_fee if type == :supplying

      {
        recipient_id: boutique.recipient_id,
        boutique_id: boutique.id,
        value: value
      }
    end
  end
end
