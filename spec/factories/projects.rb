FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    association :user, factory: :user

    factory :project_with_navers do
      after(:create) do |project|
        create_list(:naver, rand(1...20), projects: [project])
      end
    end
  end
end
