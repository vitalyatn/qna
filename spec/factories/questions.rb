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

      trait :with_file do
        files { [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb"), fixture_file_upload("#{Rails.root}/spec/spec_helper.rb") ]}
      end
    end
  end

