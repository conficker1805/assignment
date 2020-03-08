class Respondent
  class Answer < ApplicationRecord
    # Kaminari item per page
    paginates_per 10

    # Association
    belongs_to :respondent
    belongs_to :question

    # Validations
    validates :question_id, :body, presence: true
    validates :body, length: { in: 1..256 }, if: -> { question.open_ended? }
    validate :unique_submission, on: :create
    validate :valid_body

    private

    def unique_submission
      raise Error::Answer::SubmitTwice if respondent.answers.pluck(:question_id).include? question_id
    end

    def valid_body
      if question.scored? && score_out_of_range
        raise Error::Params::Invalid, "Your answer should be a number from 1 to 5"
      end
    end

    def score_out_of_range
      !(body =~ /^-?[1-5]+$/)
    end
  end
end
