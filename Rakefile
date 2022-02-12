# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# Load the Rails application.
require_relative "config/application"

Rails.application.load_tasks

# For normal rails logging within rake tasks
Rails.logger = Logger.new($stdout)
Rails.application.configure { config.log_level = :warn }

if %w(development test).include? Rails.env
  require "bundler/audit/task"
  require "rspec/core/rake_task"
  require "rubocop/rake_task"

  # setup task bundle:audit
  Bundler::Audit::Task.new

  # setup task rspec
  RSpec::Core::RakeTask.new(:rspec) do |t|
    # t.exclude_pattern = "**/{system}/**/*_spec.rb" # example, here how to skip integration specs
  end

  # setup taks rubocop and rubocop:auto_correct
  RuboCop::RakeTask.new

  desc "Run rubocop and the specs"
  task ci: %w(rubocop rspec bundle:audit)

  task default: :ci
end

desc "Only dump the schema when adding a new migration"
task faster_migrations: :environment do
  ActiveRecord.dump_schema_after_migration = Rails.env.development? && `git status db/migrate/ --porcelain`.present?
end

desc "Prepend faster_migrations task before db:migrate"
task "db:migrate": "faster_migrations"

desc "Keep DB columns in schema.db sorted"
task "db:schema:dump": "strong_migrations:alphabetize_columns"
