class ApplicationController < ActionController::API
  include ExceptionHandler

  around_action :listening_exception

  protected

  def standardize_params
    ActionController::Parameters.new(
      params.permit!.to_h.deep_transform_keys(&:underscore)
    )
  end
end
