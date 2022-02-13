# Use the same logging setup on all environments

Rails.application.configure do
  config.log_level = Settings.log_level

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  logger           = ActiveSupport::Logger.new(Settings.log_target)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
end
