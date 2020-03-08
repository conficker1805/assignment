FactoryBot.define do
  factory :respondent do
    sequence(:identifier) { |n| "0000#{n}" }

    trait :male do
      after(:create) do |respondent, evaluator|
        respondent.create_profile(gender: 'Male', department: Faker::Job.field)
      end
    end

    trait :female do
      after(:create) do |respondent, evaluator|
        respondent.create_profile(gender: 'Female', department: Faker::Job.field)
      end
    end
  end
end
