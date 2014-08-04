class ShippingEventsController < ApplicationController
  def create
    e = EasyPost::Event.receive(request.body.string)

    ShippingEvent.create({
      event_id:            e.id,
      object:              e.object,
      mode:                e.mode,
      description:         e.description,
      previous_attributes: e.previous_attributes,
      result:              e.result
    })

    render(nothing: true, status: 200)
  end
end
