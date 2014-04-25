class Notifier < ActionMailer::Base
  default from: "no-reply@trunkit.com"

  def welcome_email(user)
    @user = user

    mail(to: user.email, subject: "Welcome to Trunkit")
  end

  def boutique_signup(params)
    @params = params

    mail({
      to: ["wweidendorf@gmail.com", "team@trunkit.com"],
      subject: "[TrunkIt] Boutique Signup"
    })
  end
end
