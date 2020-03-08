wrapper(json) do
  json.partial! 'api/v1/shared/page', items: @answers

  json.set! :responses do
    json.array! @answers do |answer|
      json.(answer, :question_id, :body)
    end
  end
end
