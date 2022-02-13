class ApplicationController < ActionController::Base
  before_action :initialize_request_context

  # throwing the error here, after catching it in our routes,
  # means our normal error handler process will be used
  # to log the error and display a message to the user
  def error_404
    fail ActionController::RoutingError, "Path #{request.path} could not be found"
  end

  private

  def initialize_request_context
    Current.module_name = self.class.module_parent_name || "App"
    Current.path = request.path
    Current.request_id = request.request_id # set via Rack::RequestId gem & ActionDispatch::RequestId
  end
end
