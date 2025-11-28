require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module JobAnalyzer
  class Application < Rails::Application
    
    config.load_defaults 8.0
    config.i18n.available_locales = [:en, :pt]
    config.i18n.default_locale = :en

    config.generators do |g|
      g.orm :mongoid
    end
  end
end