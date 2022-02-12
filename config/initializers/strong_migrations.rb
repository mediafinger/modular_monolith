# Mark existing migrations as safe
StrongMigrations.start_after = 20220212223654

# Set timeouts for migrations
# If you use PgBouncer in transaction mode, delete these lines and set timeouts on the database user
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour # for long running data migrations

# Analyze tables after indexes are added
# Outdated statistics can sometimes hurt performance
StrongMigrations.auto_analyze = true

# Set the version of the production database
# so the right checks are run in development
StrongMigrations.target_version = 11

# Check rollback / down migrations as well
StrongMigrations.check_down = true

# Add custom checks
# StrongMigrations.add_check do |method, args|
#   if method == :add_index && args[0].to_s == "users"
#     stop! "No more indexes on the users table"
#   end
# end

# Make some operations safe by default
# * adding and removing an index
# * adding a foreign key
# * adding a check constraint
# * setting NOT NULL on an existing column
# See https://github.com/ankane/strong_migrations#safe-by-default
StrongMigrations.safe_by_default = true
