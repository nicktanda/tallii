class Pet < ApplicationRecord
  belongs_to :user
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :images

  enum species: { dog: 0, cat: 1, bird: 2, fish: 3, rabbit: 4, reptile: 5, other: 6 }
  enum gender: { male: 0, female: 1 }

  def age
    dob = self.dob
    now = Time.now.utc.to_date
    now.year - dob.year - (dob.to_date.change(year: now.year) > now ? 1 : 0)
  end
end