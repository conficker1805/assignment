module JsonLayoutHelper
  def wrapper(json = {})
    json.data do
      yield if block_given?
    end
  end
end
