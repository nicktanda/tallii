FactoryBot.define do
  factory :order do
    status { :pending }
    association :user
    association :organisation

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :with_products do
      after(:create) do |order|
        products = create_list(:product, 2, organisation: order.organisation)
        products.each { |product| order.products << product }
      end
    end
  end
end