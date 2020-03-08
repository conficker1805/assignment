module Api
  module V1
    class AnswersController < ApplicationController
      def index
        @answers = Respondent::Answer.all.page(params[:page])
      end

      def create
        Validate::Submission.check!(standardize_params)

        @user = Respondent.find_by!(identifier: respondent_id)
        @user.answers.create!(answer_params)
      end

      protected

      def answer_params
        standardize_params.permit(responses: %w[question_id body])
                          .fetch(:responses, [])
      end


      def respondent_id
        standardize_params[:respondent_identifier]
      end
    end
  end
end
