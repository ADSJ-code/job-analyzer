require_relative "boot"

# Pule o ActiveRecord e Action Cable/Action Text
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module JobAnalyzer
  class Application < Rails::Application
    config.load_defaults 8.0
  end
end