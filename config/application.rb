require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mytownplaylist
  class Application < Rails::Application
    config.browserify_rails.commandline_options = ['-t reactify -t envify']

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << Rails.root.join('app', 'lib')

    config.assets.paths << Rails.root.join('node_modules')
  end
end
