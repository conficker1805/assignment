wrapper(json) do
  json.set! :scored_question_distributions do
    json.array! @frequencies do |frequency|
      json.set! :question_id, frequency.question_id
      json.set! :responseFrequencies do
        json.array! (1..5).to_a do |i|
          json.set! :score, i
          json.set! :frequency, frequency.send("score_#{i}".to_sym) || 0
        end
      end
    end
  end
end
