FactoryBot.define do
  factory :naver do
    name { Faker::Name.name  }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65)  }
    admission_date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    job_role { Faker::Job.title }
    association :user, factory: :user

    factory :naver_with_projects do
      after(:create) do |naver|
        create_list(:project, rand(1...20), navers: [naver])
      end
    end
  end
end

