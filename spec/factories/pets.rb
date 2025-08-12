FactoryBot.define do
  factory :pet do
    sequence(:name) { |n| "Pet#{n}" }
    species { :dog }
    gender { :male }
    dob { 2.years.ago }
    breed { "Golden Retriever" }
    weight { 50 }
    health_conditions { "None" }
    notes { "Friendly pet" }
    status { :active }
    colour_codes { [] }
    association :user
    
    trait :cat do
      species { :cat }
      breed { "Persian" }
      weight { 10 }
    end

    trait :female do
      gender { :female }
    end

    trait :deceased do
      status { :deceased }
      date_of_death { 1.month.ago }
    end

    trait :with_medical_history do
      health_conditions { "Allergic to chicken" }
      medication { "Daily vitamins" }
      allergies { "Chicken, beef" }
    end
  end
end