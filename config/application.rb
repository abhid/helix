require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Helix
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.ise = config_for(:cisco_ise)
    config.prime = config_for(:cisco_prime)
    config.ad = config_for(:ad)

    # Enable sidekiq as the job queue
    config.active_job.queue_adapter = :sidekiq
  end
end
