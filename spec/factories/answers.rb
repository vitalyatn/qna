FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    question
    body
    user

    trait :invalid do
      body { nil }
    end
  end
end
