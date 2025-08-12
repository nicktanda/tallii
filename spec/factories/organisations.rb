FactoryBot.define do
  factory :organisation do
    sequence(:name) { |n| "Test Organisation #{n}" }
    sequence(:access_code) { |n| "TEST#{n.to_s.rjust(2, '0')}" }
    maximum_daily_daycare_visits { 10 }
    maximum_weekly_daycare_visits { 50 }
    maximum_daily_grooms { 5 }
    maximum_weekly_grooms { 25 }
    daycare_visit_reward_points { 10 }
    grooming_reward_points { 20 }
    stripe_api_key { "test_stripe_key" }
  end
end