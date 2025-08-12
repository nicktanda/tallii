FactoryBot.define do
  factory :temporary_groom do
    pet_name { "Test Pet" }
    owner_name { "Test Owner" }
    date { 1.week.from_now }
    time { "10:00" }
    status { :pending }
    last_groom { nil }
    pet_notes { nil }
    owner_notes { nil }
    employee_id { create(:user, :employee).id }
    association :organisation

    trait :today do
      date { Date.today }
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