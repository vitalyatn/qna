FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    question
    body
    user
    better { false }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb"), fixture_file_upload("#{Rails.root}/spec/spec_helper.rb") ]}
    end
  end
end
