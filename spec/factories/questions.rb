FactoryBot.define do
    sequence :title do |n|
      "MyString#{n}"
    end

    factory :question do
      title
      body { "MyText" }
      user

      trait :invalid do
        body { nil }
      end
    end
  end

