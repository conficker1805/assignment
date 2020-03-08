wrapper(json) do
  json.set! :responses do
    json.array! @answers do |answer|
      json.(answer, :question_id, :body)
    end
  end
end
