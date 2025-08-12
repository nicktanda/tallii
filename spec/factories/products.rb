FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { "A great product for your pet" }
    price { 29.99 }
    stock { 100 }
    association :organisation

    trait :out_of_stock do
      stock { 0 }
    end

    trait :expensive do
      price { 199.99 }
    end

    trait :with_reviews do
      after(:create) do |product|
        create_list(:review, 3, product: product)
      end
    end
  end
end