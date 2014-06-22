class Notifier < ActionMailer::Base
  default from: "no-reply@trunkit.com"

  def welcome_email(user)
    @user = user

    mail(to: user.email, subject: "Welcome to Trunkit")
  end

  def boutique_signup(params)
    @params = params

    mail({
      to: ["team@trunkit.com"],
      subject: "[TrunkIt] Boutique Signup"
    })
  end

  def cart_item_cancellation(cart_item_id, message)
    @cart_item = CartItem.includes(:cart).find(cart_item_id)
    @user      = User.unscoped.find(@cart_item.cart.user_id)
    @message   = message

    mail({
      to: @user.email,
      subject: "Order Update for #{@cart_item.item.name} from #{@cart_item.supporting_boutique.name}"
    })
  end
end
