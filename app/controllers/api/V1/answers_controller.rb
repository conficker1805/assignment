module Api
  module V1
    class AnswersController < ApplicationController
      def index
        @answers = Respondent::Answer.all.page(params[:page])
      end

      def create
        Validate::Submission.check!(standardize_params)

        user = Respondent.find_by!(identifier: respondent_id)

        ActiveRecord::Base.transaction do
          @answers = answer_params.map{ |h| Respondent::Answer.new(h.merge(respondent: user)) }
          @answers.map(&:save!)
        end
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
