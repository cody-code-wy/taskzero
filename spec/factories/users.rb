FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(8) }
    password_confirmation { password }

    trait :with_tasks do

    end

    trait :with_projects do

    end

    trait :with_contexts do
      after :create do |user|
        create_list :context, 5, user: user
      end
      after :build do |user|
        user.contexts = build_list :context, 5, user: user
      end
    end
  end
end
