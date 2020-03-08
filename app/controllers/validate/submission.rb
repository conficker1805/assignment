module Validate
  class Submission
    include ActiveModel::Validations

    attr_accessor :respondent_identifier, :responses

    validates :respondent_identifier, :responses, presence: true
    validate :valid_answers

    def initialize(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    rescue
    end

    def self.check!(params)
      raise Error::Params::Invalid if new(params).invalid?
    end

    private

    def valid_answers
      responses.each { |p| Validate::Answer.check!(p) }
    end
  end
end
