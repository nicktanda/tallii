class Pet < ApplicationRecord

  belongs_to :organisation
  belongs_to :user
  has_many :daycare_visits, dependent: :destroy

  enum species: { dog: 0, cat: 1, bird: 2, fish: 3, rabbit: 4, reptile: 5, other: 6 }
end