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
  t.consumer_key    = "pTbSvWnV35lgpm6DlIovZw"
  t.consumer_secret = "qWta4OSntTgtu867ew8wCIrl5han3VIjJEZZpPfnAdk"
end
