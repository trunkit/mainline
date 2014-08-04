if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.fog_directory = 'trunkit-mainline'
    # These can be found under Access Keys in AWS Security Credentials
    config.aws_access_key_id = configatron.s3.access_key_id
    config.aws_secret_access_key = configatron.s3.secret_access_key

    # Don't delete files from the store
    config.existing_remote_files = 'keep'

    # Automatically replace files with their equivalent gzip compressed version
    config.gzip_compression = true

    # Set custom headers for CORS requests
    config.headers = { ".*" => { "Access-Control-Allow-Origin" => "*", "Vary" => "Origin" }}
  end
end
