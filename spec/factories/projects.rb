FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    user { FactoryBot.build(:user) }
    kind { Project.kinds.keys.sample }
    on_hold false

    trait :with_project do
      project { FactoryBot.build(:project) }
    end

    trait :with_projects do
      projects { build_list(:project, 3) }
    end
  end
end
