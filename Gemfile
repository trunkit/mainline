source 'https://rubygems.org'

ruby '2.1.0'

# Core framework
gem 'rails', '4.0.3'

# Persistence
gem 'pg'
gem 'pg_array_parser'
gem 'paranoia'
gem 'paper_trail'

# Miscellaneous
gem 'configatron'
gem 'uuid'
gem 'certified' # For OpenSSL verify errors
gem 'will_paginate'
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
gem 'mini_magick'

# Social Networks
gem 'koala', '1.8.0.rc1'
gem 'twitter'

# Searching
gem 'sunspot_rails'

# Payments
gem 'avalara', github: 'vizjerai/avalara'
gem 'balanced'

# Assets support
gem 'bourbon'
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier',     '~> 1.3'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'unf'
gem 'asset_sync'

# Monitoring services
gem 'airbrake'
gem 'newrelic_rpm'

group :development do
  gem 'sunspot_solr'
end

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
end
