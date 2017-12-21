FactoryBot.define do
  factory :task do
    name { Faker::Lorem.words(2).join(' ') }
    kind { Task.kinds.keys.sample }
    description { Faker::Lorem.words(25).join(' ') }
    complete false
    user { FactoryBot.build(:user) }

    trait :with_project do
      project { FactoryBot.build(:project) }
    end

    trait :with_context do
      context { FactoryBot.build(:context) }
    end
  end
end
