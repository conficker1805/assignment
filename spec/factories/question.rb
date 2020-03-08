FactoryBot.define do
  factory :question do
    prompt { Faker::Lorem.sentence }
    optional { true }
    type { :open_ended }

    trait :scored do
      type { :scored }
    end
  end
end
