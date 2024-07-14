class OnboardingPet < ApplicationRecord
  belongs_to :user
  has_many :images

  enum species: { dog: 0, cat: 1, bird: 2, fish: 3, rabbit: 4, reptile: 5, other: 6 }
  enum gender: { male: 0, female: 1 }
end