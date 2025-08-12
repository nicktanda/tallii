FactoryBot.define do
  factory :product_order_join do
    association :order
    association :product
  end
end