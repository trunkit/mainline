source 'https://rubygems.org'

ruby '2.0.0'

# Core framework
gem 'rails', '4.0.1'

# Persistence
gem 'pg'
gem 'pg_array_parser'
gem 'paranoia'
gem 'paper_trail', '3.0.0.rc2'

# Configuration
gem 'configatron'

# User authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'certified' # For OpenSSL verify errors

# Social Networks
gem 'koala', '1.8.0.rc1'
gem 'twitter'

# Payments
gem 'avalara', github: 'vizjerai/avalara'
gem 'balanced'

# Assets support
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier',     '~> 1.3'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'unf'
gem 'asset_sync'

# Monitoring services
gem 'airbrake'
gem 'newrelic_rpm'

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
end
