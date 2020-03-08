module Api
  module V1
    class QuestionsController < ApplicationController
      def scored
        answers = Respondent::Answer.where(question: Question.scored)
        avg_arr = answers.group(:question_id).average('CAST (body AS INTEGER)')
        @questions = avg_arr.map{ |i| Question.new([:id, :avg].zip(i).to_h) }
      end

      def distributions
        answers      = Respondent::Answer.where(question: Question.scored)
        @frequencies = answers.group(:question_id, :body).pluck("question_id , body, count(body)")

        @frequencies = @frequencies.map{ |i| [:id, :score, :frequency].zip(i).to_h }
        @frequencies = @frequencies.group_by{ |i| i[:id] }.map do |i|
          attrs = { question_id: i.first }
          i.last.each{|i| attrs = attrs.merge("score_#{i[:score]}": i[:frequency])}
          OpenStruct.new(attrs)
        end
      end

      def demographic
        Respondent::Profile.gender.values.each do |gender|
          var_name = "@#{gender.parameterize.underscore}_answers"
          answers  = Respondent::Answer.fetch_answers_by_gender(gender)
          answers  = answers.map{ |i| Question.new([:id, :avg].zip(i).to_h) }
          instance_variable_set var_name.to_sym, answers
        end
      end
    end
  end
end
