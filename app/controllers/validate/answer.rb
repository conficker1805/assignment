module Validate
  class Answer
    include ActiveModel::Validations

    attr_accessor :question_id, :body

    validates :question_id, :body, presence: true

    def initialize(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    rescue
    end

    def self.check!(params)
      raise Error::Params::Invalid if new(params).invalid?
    end
  end
end
