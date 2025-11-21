require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false

  config.public_file_server.enabled = true
  config.assets.compile = false

  config.assume_ssl = false
  config.force_ssl = false
  
  config.hosts.clear 


  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false
  config.require_master_key = false 
  config.new_framework_defaults_8_0 = true
end