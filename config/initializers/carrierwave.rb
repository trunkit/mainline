CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              "AWS",
    aws_access_key_id:     configatron.s3.access_key_id,
    aws_secret_access_key: configatron.s3.secret_access_key
  }

  config.fog_directory = (Rails.env.production? ? "trunkit-content" : "trunkit-content-development")
  config.asset_host    = "http://#{config.fog_directory}.s3.amazonaws.com"
end
