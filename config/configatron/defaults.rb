# Put all your default configatron settings here.

# Example:
#   configatron.emails.welcome.subject = 'Welcome!'
#   configatron.emails.sales_reciept.subject = 'Thanks for your order'
#
#   configatron.file.storage = :s3

configatron.s3.access_key_id     = "AKIAIVXNOE4PA6LP7BJQ"
configatron.s3.secret_access_key = "5cp59VhNKi7T+c5jSxz6A0r7F98Ld0uqVd/dldNw"

configatron.facebook do |f|
  f.id     = "652420558116466"
  f.secret = "6adb28b82b59e95760582f2bc5da3d3b"
end

configatron.twitter do |t|
  t.consumer_key    = "QsBW1ibb2IW6JmWrQY9iw"
  t.consumer_secret = "V90sTc3Fw0sqGF25pc2qBV2SZEkNxbdEopzX2N8nk"
end

configatron.stripe do |s|
  s.secret_key      = "sk_test_NxUPQyRW4aF39IWHvKHyO2Ev"
  s.publishable_key = "pk_test_31Yysb03a8l44XjjHbM5vKgm"
end
