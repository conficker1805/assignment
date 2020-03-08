class ApplicationController < ActionController::API
  include ExceptionHandler

  helper JsonLayoutHelper

  around_action :listening_exception

  protected

  def page
    params.fetch(:page, 1)
  end

  def standardize_params
    ActionController::Parameters.new(
      params.permit!.to_h.deep_transform_keys(&:underscore)
    )
  end
end
