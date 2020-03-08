class Respondent
  class Answer < ApplicationRecord
    # Association
    belongs_to :respondent
    belongs_to :question

    # Validations
    validate :unique_submission
    validates :question_id, :body, presence: true

    private

    def unique_submission
      raise Error::Answer::SubmitTwice if respondent.answers.pluck(:question_id).include? question_id
    end
  end
end
