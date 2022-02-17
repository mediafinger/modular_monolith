# Maintain your gem's version:
require_relative "lib/admin_engine/version"

Gem::Specification.new do |spec|
  spec.name        = "admin_engine"
  spec.version     = AdminEngine::VERSION
  spec.authors     = ["Andreas Finger"]
  spec.email       = ["webmaster@mediafinger.com"]
  spec.homepage    = "https://mediafinger.com"
  spec.summary     = "admin_engine is an engine inside the modular_monolith"
  spec.description = "the admin_engine manages admins and authentication"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "http://github.com/mediafinger"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mediafinger/modular_monolith"
  spec.metadata["changelog_uri"] = "https://github.com/mediafinger/modular_monolith/CHANGELOG"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "rails", "~> 7.0.2"

  spec.add_dependency "pg" # , "~> 1.1" # Use postgresql as the database for Active Record

  # spec.add_dependency "activerecord-postgres_enum", "~> 2.0"
  # spec.add_dependency "oj" # , "~> 3.13" # fast JSON parser: https://github.com/ohler55/oj
  # spec.add_dependency "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]

  spec.add_development_dependency "amazing_print", "~> 1.4" # pretty printing in the console: https://github.com/amazing-print/amazing_print
  spec.add_development_dependency "bundler-audit", "~> 0.9" # scanning dependencies for known CVEs: https://github.com/rubysec/bundler-audit
  spec.add_development_dependency "rspec-rails", "~> 5.1" # rails wrapper for test framework: https://github.com/rspec/rspec-rails
  spec.add_development_dependency "rubocop", "~> 1.25" # code linter: https://github.com/rubocop/rubocop
  spec.add_development_dependency "rubocop-performance" # plugin: https://github.com/rubocop/rubocop-performance
  spec.add_development_dependency "rubocop-rails" # plugin: https://github.com/rubocop/rubocop-rails
  spec.add_development_dependency "rubocop-rake" # plugin: https://github.com/rubocop/rubocop-rake
  spec.add_development_dependency "rubocop-rspec" # plugin: https://github.com/rubocop/rubocop-rspec
  spec.add_development_dependency "webmock", "~> 3.14" # stub HTTP requests: https://github.com/bblimke/webmock

  # default gems (here still unused) to (also) be used be the Engines
  # spec.add_development_dependency "capybara" # simulate browsing websites: https://github.com/teamcapybara/capybara
  # spec.add_development_dependency "debug", platforms: %i(mri mingw x64_mingw) # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # spec.add_development_dependency "factory_bot" # avoid fixtures: https://github.com/thoughtbot/factory_bot
  # spec.add_development_dependency "faker" # generate fake data: https://github.com/faker-ruby/faker
  # spec.add_development_dependency "rswag-specs" # test OpenAPI documentation against API: https://github.com/rswag/rswag
end
