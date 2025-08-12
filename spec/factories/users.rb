FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "First#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    rewards_points { 100 }
    max_daycare_visits { 10 }
    role { :customer }
    active { true }
    association :organisation

    trait :employee do
      role { :employee }
    end

    trait :customer do
      role { :customer }
    end

    trait :admin do
      role { :admin }
    end
  end
end