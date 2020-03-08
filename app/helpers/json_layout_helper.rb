module JsonLayoutHelper
  def wrapper(json = {})
    json.success true
    json.data do
      yield if block_given?
    end
  end
end
