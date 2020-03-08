FactoryBot.define do
  factory :answer, class: 'Respondent::Answer' do
    association :question
    association :respondent
    body { Faker::Lorem.sentence }

    trait :scored do
      body { (1..5).to_a.sample }
    end
  end
end
