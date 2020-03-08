wrapper(json) do
  json.set! :questionAverages do
    json.array! @questions do |question|
      json.set! :question_id, question.id
      json.set! :average_score, question.avg.to_f
    end
  end
end
