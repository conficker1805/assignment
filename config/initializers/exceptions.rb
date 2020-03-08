KNOWN_EXCEPTIONS = [
  'Error::ActiveModel::UnknownAttributeError',
  'Error::ActiveRecord::RecordNotFound',
  'Error::Params::Invalid',
  'Error::Answer::SubmitTwice'
]

module ExceptionInitialize
  define_method :initialize do |message = nil, status = nil|
    base = self.class.name.gsub('::', '.').downcase
    message = message || I18n.t(base + '.message', scope: :api)
    status  = I18n.t(base + '.status', scope: :api, default: 500)
    super(message, status)
  end
end

Error = Module.new

Error.const_set('Base', Class.new(::StandardError) do
  attr_reader :status, :message

  define_method :initialize do |message, status|
    @message, @status = [message, status]
  end
end)

KNOWN_EXCEPTIONS.each do |klass|
  arr = klass.split('::')
  full = "#{arr.shift}::"

  arr.length.times do
    name = arr.shift
    if arr.length > 0
      Error.const_set(name, Module.new)
      full += "#{name}"
    else
      full.constantize.const_set(name, Class.new(Error::Base) do
        include ExceptionInitialize
      end)
    end
  end
end

# Error.const_set('ActiveRecord', Module.new)
# Error::ActiveRecord.const_set('RecordNotFound', Class.new(Error::Base) do
#   include ExceptionInitialize
# end)

# Error.const_set('InvalidCredential', Class.new(Error::Base) do
#   include ExceptionInitialize
# end)
