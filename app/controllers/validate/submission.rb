module Validate
  class Submission
    include ActiveModel::Validations

    attr_accessor :respondent_identifier, :responses

    validates :respondent_identifier, :responses, presence: true
    validate :duplicate_answers
    validate :valid_answers
    validate :mandatory_answers

    def initialize(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    rescue
    end

    def self.check!(params)
      new(params).invalid?
    end

    private

    def valid_answers
      responses.each { |p| Validate::Answer.check!(p) }
    end

    def duplicate_answers
      if response_ids.uniq.size != responses.size
        raise Error::Params::Invalid, 'Are you giving response twice on a question?'
      end
    end

    def mandatory_answers
      question_ids = Question.required.ids
      responsed_ids = response_ids.map(&:to_i)

      if (question_ids & responsed_ids).size != question_ids.size
        raise Error::Params::Invalid, 'Please give response for mandatory questions.'
      end
    end

    def response_ids
      @_qids ||= responses.pluck(:question_id)
    end
  end
end
