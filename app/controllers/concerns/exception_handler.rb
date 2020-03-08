module ExceptionHandler
  def listening_exception
    begin
      yield
    rescue NameError => e
      render json: { message: (Rails.env.production? ? I18n.t('api.info.something_wrong') : e.message) }, status: 500
    rescue StandardError => e
      if KNOWN_EXCEPTIONS.include? e.class.name
        res = ExceptionFormat.new(e)
        render json: { success: false, message: res.message }, status: res.status
      else
        raise e
      end
    end
  end
end
