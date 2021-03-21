FactoryBot.define do
  factory :project do
    name { Faker::Name.unique.first_name }
    association :user, factory: :user

    factory :project_with_navers do
      after(:create) do |project|
        create_list(:naver, rand(1...20), projects: [project], user: project.user)
      end
    end
  end
end
