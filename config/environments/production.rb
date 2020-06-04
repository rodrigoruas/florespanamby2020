Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
config.webpacker.check_yarn_integrity = false

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_mailer.delivery_method     = :postmark
  config.action_mailer.postmark_settings   = { api_key: ENV['POSTMARK_API_KEY'] }
  config.action_mailer.default_url_options = { host: "floretal.com.br" }
  config.action_mailer.perform_deliveries = true

  config.read_encrypted_secrets = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony: true)

  config.assets.compile = false

  config.force_ssl = true

  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false


  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  Raven.configure do |config|
    config.dsn = 'https://eef10adee4df4ae6b50c9ec8d8c7ae16:2e3acabe2b364c19b9e64857b8278805@o383837.ingest.sentry.io/5214275'
  end



  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
