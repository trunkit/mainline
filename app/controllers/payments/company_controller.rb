class Payments::CompanyController < CatalogAbstractController
  skip_before_filter :validate_boutique

  before_filter do
    redirect_to(stream_path) if current_user.parent.blank?
  end

  def show
    current_user.parent.recipient_id.present? ?
      redirect_to(action: :edit) :
      redirect_to(action: :new)
  end

  def new
    @recipient = Hashie::Mash.new
  end

  def create
    recipient = Stripe::Recipient.create(recipient_params)
    current_user.parent.update_attribute(:recipient_id, recipient.id)
    redirect_to(stream_path)

  rescue Stripe::InvalidRequestError => e
    @error     = e.message
    @recipient = Hashie::Mash.new

    render(action: :new)
  end

  def edit
    @recipient = current_user.parent.recipient
  end

  def update
    recipient = current_user.parent.recipient

    recipient_params.each do |key, value|
      recipient.public_send("#{key}=", value)
    end

    recipient.save

    redirect_to(action: :edit)
  end

private
  def recipient_params
    params.require(:recipient).permit(:name, :tax_id, bank_account: [:routing_number, :account_number, :country]).tap do |whitelisted|
      whitelisted[:type] = "corporation"
    end
  end
end
