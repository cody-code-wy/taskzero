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
      projects { build_list :project, 3, user: nil }
    end

    trait :with_contexts do
      contexts { build_list :context, 3, user: nil }
    end
  end
end
