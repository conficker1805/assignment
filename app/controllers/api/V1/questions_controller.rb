module Api
  module V1
    class QuestionsController < ApplicationController
      def scored
        answers = Respondent::Answer.where(question: Question.scored)
        avg_arr = answers.group(:question_id).average('CAST (body AS INTEGER)')
        @questions = avg_arr.map{ |i| Question.new([:id, :avg].zip(i).to_h) }
      end
    end
  end
end
