class StatusController < ApplicationController # Api-only Controller would be sufficient
  def alive
    head :ok
  end

  # TODO: do things that can actually fail, like some DB connection
  def ready
    head :ok
  rescue StandardError => e
    raise Errors::ServiceUnavailable.new(
      "#{Settings.app_name} failed readiness check on #{Settings.environment}",
      backtrace: e.backtrace
    )
  end

  def version
    render json: Settings.app_version, status: :ok
  end
end
