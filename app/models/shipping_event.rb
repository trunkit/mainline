class ShippingEvent < ActiveRecord::Base
  after_save :check_shipped, :check_delivered

  def result
    @result ||= Hashie::Mash.new(result)
  end

private

  def check_shipped
    return unless status == "tracker.updated"

    if status == "in_transit"
      ci = CartItem.where(tracking_code: result.tracking_code).first
      ci.update_attribute(:shipped_at, Time.now) if ci
    end
  end

  def check_delivered
    return unless status == "tracker.updated"

    if status == "delivered"
      ci = CartItem.where(tracking_code: result.tracking_code).first
      ci.update_attribute(:delivered_at, Time.now) if ci
    end
  end
end
