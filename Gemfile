source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2", ">= 7.0.2.2"

gem "oj", "~> 3.13" # fast JSON parser: https://github.com/ohler55/oj
gem "pg", "~> 1.1" # Use postgresql as the database for Active Record
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "puma", "~> 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "rack-requestid", "~> 0.2" # set a request_id in the middleware: https://github.com/dancavallaro/rack-requestid
gem "rack-timeout", "~> 0.6", require: "rack/timeout/base" # set a custom timeout in the middleware: https://github.com/sharpstone/rack-timeout
gem "strong_migrations", "~> 0.8" # detect unsafe migrations: https://github.com/ankane/strong_migrations
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby) # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

# default gems (here still unused) to (also) be used be the Engines
# gem "activerecord-postgres_enum", "~> 2.0" # migration and schema.rb support for PostgreSQL enums: https://github.com/bibendi/activerecord-postgres_enum
# gem "chimera_http_client" # flexible http-client with a nice interface, wraps libcurl: https://github.com/mediafinger/chimera_http_client
# gem "devise" # all frills authentication solution: https://github.com/heartcombo/devise
# gem "dry-schema" # parameter validation: https://github.com/dry-rb/dry-schema
# gem "jsonapi-serializer" # fast JSON:API serialization with clear interface: https://github.com/jsonapi-serializer/jsonapi-serializer
# gem "pagy" # pagynation with a flexible plugin system: https://ddnexus.github.io/pagy/
# gem "pundit" # pure ruby authorization solution: https://github.com/varvet/pundit
# gem "sidekiq" # background processing / job queueing: https://github.com/mperham/sidekiq
# gem "rswag-api" # generate OpenAPI documentation: https://github.com/rswag/rswag
# gem "rswag-ui" # provide interactive OpenAPI UI: https://github.com/rswag/rswag

# internal engines
gem "user_engine", path: "engines/user_engine"

group :development do
  # tdb
end

group :development, :test do
  gem "amazing_print", "~> 1.4" # pretty printing in the console: https://github.com/amazing-print/amazing_print
  gem "bundler-audit", "~> 0.9" # scanning dependencies for known CVEs: https://github.com/rubysec/bundler-audit
  gem "rspec-rails", "~> 5.1" # rails wrapper for test framework: https://github.com/rspec/rspec-rails
  gem "rubocop", "~> 1.25" # code linter: https://github.com/rubocop/rubocop
  gem "rubocop-performance" # plugin: https://github.com/rubocop/rubocop-performance
  gem "rubocop-rails" # plugin: https://github.com/rubocop/rubocop-rails
  gem "rubocop-rake" # plugin: https://github.com/rubocop/rubocop-rake
  gem "rubocop-rspec" # plugin: https://github.com/rubocop/rubocop-rspec

  # default gems (here still unused) to (also) be used be the Engines
  # gem "capybara" # simulate browsing websites: https://github.com/teamcapybara/capybara
  # gem "debug", platforms: %i(mri mingw x64_mingw) # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "factory_bot" # avoid fixtures: https://github.com/thoughtbot/factory_bot
  # gem "faker" # generate fake data: https://github.com/faker-ruby/faker
  # gem "rswag-specs" # test OpenAPI documentation against API: https://github.com/rswag/rswag
end

group :test do
  gem "webmock", "~> 3.14" # stub HTTP requests: https://github.com/bblimke/webmock
end
