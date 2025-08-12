FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "A category for pet products" }
    association :organisation

    trait :with_products do
      after(:create) do |category|
        products = create_list(:product, 3, organisation: category.organisation)
        products.each { |product| category.products << product }
      end
    end
  end
end