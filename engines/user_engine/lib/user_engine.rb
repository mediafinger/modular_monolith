require "user_engine/version"
require "user_engine/engine"

module UserEngine
  # Your code goes here...
end

# Only trigger zeitwerk after defining the Engine
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

loader.eager_load
