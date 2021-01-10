require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Multi0Design
  class Application < Rails::Application
    config.load_defaults 6.1

    config.encoding = 'utf-8'
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.beginning_of_week = :monday

    config.active_record.default_timezone = :local
    config.active_record.schema_format = :ruby

    console do
      require "pry"
      config.console = Pry
    end

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework false
    end
  end
end
