FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    association :user, factory: :user
  end
end
