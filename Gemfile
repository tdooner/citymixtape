source 'https://rubygems.org'

gem 'rails', github: 'rails/rails'
gem 'puma'
gem 'haml'

gem 'sidekiq'

# Javascript
gem 'browserify-rails'
gem 'jquery-rails'
gem 'coffee-script'

# API libraries
gem 'rspotify'
gem 'songkickr'

group :development, :test do
  gem 'sqlite3'
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
  gem 'pg'
  gem 'rails_12factor'
end
