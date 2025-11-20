FactoryBot.define do
  factory :daycare_visit do
    date { 1.week.from_now }
    start_time { "09:00" }
    duration { :half_day }
    status { :pending }
    notes { "Regular daycare visit" }
    association :pet
    association :organisation
    employee_id { create(:user, :employee).id }

    trait :today do
      date { Date.today }
    end

    trait :past do
      date { 1.week.ago }
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