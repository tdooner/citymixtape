source 'https://rubygems.org'

gem 'rails', '5.0.0.beta2'
gem 'puma'
gem 'haml'
gem 'pg'

gem 'sidekiq'

# Javascript
gem 'browserify-rails'
gem 'jquery-rails'
gem 'coffee-rails'

# API libraries
gem 'rspotify'
gem 'songkickr'

group :development, :test do
  gem 'pry-rails'
  gem 'byebug'
end

group :test do
  gem 'rspec'
end

group :development do
  gem 'web-console', '~> 3.0'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'rails_12factor'
  gem 'uglifier'
end
