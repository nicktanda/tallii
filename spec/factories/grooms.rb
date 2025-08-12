FactoryBot.define do
  factory :groom do
    date { 1.week.from_now }
    time { "10:00" }
    status { :pending }
    notes { "Regular grooming session" }
    last_groom { nil }
    association :pet
    association :organisation
    employee_id { create(:user, :employee).id }

    trait :today do
      date { Date.today }
    end

    trait :past do
      date { 1.week.ago }
      
      after(:build) do |groom|
        groom.save(validate: false) if groom.persisted?
      end
    end

    trait :confirmed do
      status { :confirmed }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end

    trait :missed do
      status { :missed_appointment }
    end

    trait :with_last_groom do
      last_groom { 3.months.ago }
    end
  end
end