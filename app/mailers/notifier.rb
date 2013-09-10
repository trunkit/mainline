class Notifier < ActionMailer::Base
  default from: "no-reply@trunkit.com"

  def welcome_email(user)
    @user = user

    mail(to: user.email, subject: "Welcome to Trunkit")
  end
end
