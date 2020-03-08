wrapper(json) do
  json.set! :profile_segment_scores do
    json.array! Respondent::Profile.gender.values do |gender|
      json.set! :segment do
        json.set! :gender, gender
      end

      json.set! :question_averages do
        json.array! instance_variable_get("@#{gender.parameterize.underscore}_answers") do |question|
          json.set! :question_id, question.id
          json.set! :average_score, question.avg.to_f
        end
      end
    end
  end
end
