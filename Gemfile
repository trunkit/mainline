source 'https://rubygems.org'

ruby '2.1.1'

# Core framework
gem 'rails', '4.1.8'

# Persistence
gem 'pg'
gem 'pg_array_parser'
gem 'paranoia'
gem 'acts_as_tree'
gem 'acts_as_list'
gem 'paper_trail'

# Miscellaneous
gem 'configatron'
gem 'uuid'
gem 'certified' # For OpenSSL verify errors
gem 'redcarpet'

# Memcache support
gem 'memcachier'
gem 'dalli'

# User authentication, authorization, and access control
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'role_model'
gem 'cancan'

# File upload support
gem 'fog'
gem 'carrierwave'
gem 'mini_magick', '3.5.0'
gem 'jquery-fileupload-rails'

# Social Networks
gem 'koala',   '1.9.0'
gem 'twitter', '5.7.1'

# Search
gem 'kaminari'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Shipping & Payments
gem 'easypost'
gem 'stripe'

# Background Processing
gem 'sidekiq'

# Assets support
gem 'bourbon'
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier',     '~> 1.3'
gem 'jquery-rails'
gem 'unf'
gem 'asset_sync'

# Monitoring services
gem 'airbrake'
gem 'newrelic_rpm'

# API documentation
gem 'swagger-docs'

group :staging, :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
end
