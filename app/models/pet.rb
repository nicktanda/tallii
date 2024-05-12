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

  def next_groom
    return if self.grooms.empty?

    groom_date = self.grooms.order(date: :asc).first.date
    return groom_date.strftime("%B %d, %Y") unless groom_date > Time.now
  end

  def last_groom
    return if self.grooms.empty?

    groom_date = self.grooms.order(date: :desc).first.date
    return groom_date.strftime("%B %d, %Y") unless groom_date < Time.now
  end
end