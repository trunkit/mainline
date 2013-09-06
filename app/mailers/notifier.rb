class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
  end
end
