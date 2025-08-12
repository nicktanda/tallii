FactoryBot.define do
  factory :temporary_daycare_visit do
    pet_name { "Test Pet" }
    owner_name { "Test Owner" }
    date { 1.week.from_now }
    time { "09:00" }
    duration { :half_day }
    status { :pending }
    pet_notes { nil }
    owner_notes { nil }
    employee_id { create(:user, :employee).id }
    association :organisation

    trait :today do
      date { Date.today }
    end

    trait :full_day do
      duration { :full_day }
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
  end
end