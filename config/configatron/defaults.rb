configatron.easypost do |e|
  e.secret_key      = "fMEShqF5KxtCpPuaB40wJA"
  e.publishable_key = ""
end

configatron.facebook do |f|
  f.id     = "652420558116466"
  f.secret = "6adb28b82b59e95760582f2bc5da3d3b"
end

configatron.twitter do |t|
  t.consumer_key    = "QsBW1ibb2IW6JmWrQY9iw"
  t.consumer_secret = "V90sTc3Fw0sqGF25pc2qBV2SZEkNxbdEopzX2N8nk"
end

configatron.s3 do |s3|
  s3.access_key_id     = "AKIAJESZBS3BIWGW6F3Q"
  s3.secret_access_key = "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"
end

configatron.stripe do |s|
  s.secret_key      = "sk_test_NxUPQyRW4aF39IWHvKHyO2Ev"
  s.publishable_key = "pk_test_31Yysb03a8l44XjjHbM5vKgm"
end
