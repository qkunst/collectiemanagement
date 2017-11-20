require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class StripXForwardedHost
  def initialize(app)
    @app = app
  end

  def call(env)
    env.delete('HTTP_X_FORWARDED_HOST')
    @app.call(env)
  end
end

module SourceQkunstbeheer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.middleware.use StripXForwardedHost

  end
end


