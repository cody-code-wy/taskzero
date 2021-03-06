FactoryBot.define do
  factory :context do
    name { Faker::Hobbit.location }
    user { FactoryBot.build(:user) }

    trait :with_context do
      context { FactoryBot.build(:context) }
    end
    trait :with_contexts do
      contexts { build_list :context, 3 }
    end
  end
end
