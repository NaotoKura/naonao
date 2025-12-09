require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    #config.load_defaults 7.0
    config.i18n.default_locale = :ja
    # 追記
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local

    if Rails.env.development? || Rails.env.test?
      begin
        require 'natto'
      rescue LoadError
        puts "natto が読み込めませんでした（development/test）。"
      end
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
