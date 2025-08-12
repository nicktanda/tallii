FactoryBot.define do
  factory :image do
    name { "test_image" }
    association :user

    trait :with_attachment do
      after(:build) do |image|
        image.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end