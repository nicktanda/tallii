require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tallii
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_record.schema_format = :sql

    config.eager_load_paths << Rails.root.join("lib")

    config.generators.system_tests = nil
  end
end
