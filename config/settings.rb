# frozen_string_literal: true

# Instead of using ENV variables in the code,
#   read them at startup and store them in this Settings object.
# This allows to:
# - work with default values,
# - overwrite some values in a config/settings.local.rb file,
# - compare values type agnostic with the `.is?` method,
# - ensure that unset ENV raise an error at 'compile' time
# - ensure that typos in the variable names are detected at 'compile' time
# - see all keys of externally set values in one file
# and this all comes without the help of another dependency.

# EXAMPLES how to use this class:
#
# register :server_name
# register :api_base_url, default: "https://example.com/api"
# register :api_username, default: "development"
# register :api_password, default: "secret" # use default for development and test, not production
#
# This tries to read the ENV variables: SERVER_NAME, API_BASE_URL, API_USERNAME, API_PASSWORD
#
# When an ENV is set, it's value will be used.
# When an ENV is not set and a default is given, it will use the default.
# When an ENV is not set and no default is given, it will be nil.
# When an ENV is not set and `mandatory: true' is and it's a `production?` environment, it will raise an error on boot.
#
# Access the objects in the code from anywhere like this:
# Settings.server_name / Settings.api_base_url ...

class Settings
  class << self
    # sets instance variable with given name and value
    def set(var_name, value)
      instance_variable_set("@#{var_name}", value)
    end

    # creates getter method that reads the instance variable with given name
    # sets value from ENV variable
    #   or `default` value
    # will raise a KeyError on boot when `mandatory: true` but ENV variable not set (on production? only)
    # `prefix` can be used to read namespaced ENV while using shorter var_names internally
    #   e.g.: register :port, prefix: "ENGINE_X"
    #   will read ENV["ENGINE_X_PORT"] and store it in port
    def register(var_name, default: nil, prefix: nil, mandatory: false)
      define_singleton_method(var_name) { instance_variable_get("@#{var_name}") }

      env_name = [prefix, var_name].compact.join("_").upcase
      value = mandatory && production? ? ENV.fetch(env_name) : ENV.fetch(env_name, default)

      set(var_name, value)
    end

    # to compare a setting vs a value and 'ignore' type, no more Boolean or Number mis-comparisons
    def is?(var_name, other_value)
      public_send(var_name.to_sym).to_s == other_value.to_s
    end

    # for testing you might decide to not treat "dev" as a production environment
    def production?
      ENV["RAILS_ENV"] == "production" || ENV["RAILS_ENV"] == "staging"
    end

    # debugging helper
    def env_and_version
      return [ENV["RAILS_ENV"], ENV["APP_COMMIT_SHA"]].compact.join("-") if production?

      "#{ENV['RAILS_ENV']}-#{`cat .git/HEAD`.split('/').last.strip}" # locally it uses the branch name
    rescue
      ENV["RAILS_ENV"]
    end
  end

  register :environment, default: ENV["RAILS_ENV"] || "development"

  register :app_host, default: "localhost"
  register :app_name, default: "App"
  register :app_port, default: 3000
  register :app_root, default: File.dirname(__dir__), mandatory: true
  register :app_version, default: env_and_version

  register :app_db_name, default: "app_#{environment}", mandatory: true
  register :app_db_host, default: "localhost", mandatory: true
  register :app_db_port, default: 5432, mandatory: true
  register :app_db_username, default: "postgres", mandatory: true
  register :app_db_password, default: nil, mandatory: true

  register :rails_max_threads, default: 5, mandatory: true
  register :rails_serve_static_files, default: false
  register :secret_key_base, mandatory: true

  # Error pages, must only be used in development
  register :display_rails_error_page, default: false
  # Adds (lograge) Rails logs to the output, only set to true in development when needed for debugging
  register :display_rails_logs, default: false

  # Logs & Logging
  register :log_level, default: Settings.is?(:environment, :test) ? :warn : :debug
  register :log_target, default: Settings.is?(:environment, :development) ? "log/#{Settings.environment}.log" : $stdout

  # rack-timeout in seconds
  register :rack_timeout, default: 12

  # Don't add secrets as 'default' values here!
  # Either set ENV vars for secrets
  #   or add them to this file, which is in .gitignore:
  load "config/settings.local.rb" if File.exist?("config/settings.local.rb")
  # inside use this syntax:
  # Settings.set :password, "secret"
end
