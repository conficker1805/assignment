class ExceptionFormat
  attr_reader :status, :message, :klass

  def initialize(e)
    @klass = @class_name = e.class.name
    @klass = "Error::#{@klass}" if !@klass.start_with?('Error::')
    @klass = @klass.constantize.new rescue false
    @message, @status = [@klass.message, @klass.status]
  end
end
