require "admin_engine/version"
require "admin_engine/engine"

module AdminEngine
  # Your code goes here...
end

# Only trigger zeitwerk after defining the Engine
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

loader.eager_load
