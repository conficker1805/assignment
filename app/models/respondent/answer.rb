class Respondent
  class Answer < ApplicationRecord
    # Kaminari item per page
    paginates_per 10

    # Association
    belongs_to :respondent
    belongs_to :question

    # Validations
    validate :unique_submission, on: :create
    validates :question_id, :body, presence: true

    private

    def unique_submission
      raise Error::Answer::SubmitTwice if respondent.answers.pluck(:question_id).include? question_id
    end
  end
end
