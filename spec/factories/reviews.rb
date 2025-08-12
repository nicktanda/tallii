FactoryBot.define do
  factory :review do
    rating { 4 }
    comment { "Great product, my pet loves it!" }
    association :product
    association :user

    trait :excellent do
      rating { 5 }
      comment { "Excellent product, highly recommended!" }
    end

    trait :poor do
      rating { 1 }
      comment { "Poor quality, would not recommend." }
    end

    trait :no_comment do
      comment { nil }
    end
  end
end