module ExceptionHandler
  def listening_exception
    begin
      yield
    rescue NameError => e
      render json: { success: false, message: I18n.t('api.info.something_wrong') }, status: 500
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, message: I18n.t('api.info.not_found') }, status: 404
    rescue ActiveRecord::RecordInvalid => e
      render_json_exception(Error::Params::Invalid.new(e.message))
    rescue StandardError => e
      if KNOWN_EXCEPTIONS.include? e.class.name
        render_json_exception(e)
      else
        raise e
      end
    end
  end

  def render_json_exception(e)
    res = ExceptionFormat.new(e)
    render json: { success: false, message: res.message }, status: res.status
  end
end
