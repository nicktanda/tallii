class Pet < ApplicationRecord
  belongs_to :user
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :images, dependent: :destroy

  enum species: { dog: 0, cat: 1, bird: 2, fish: 3, rabbit: 4, reptile: 5, other: 6 }
  enum gender: { male: 0, female: 1 }

  scope :alive, -> { where("date_of_death > ? OR date_of_death IS NULL", Date.today) }
  default_scope { alive }

  def alive?
    date_of_death > Date.today || date_of_death.nil?
  end

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

  def next_daycare_visit
    return if self.daycare_visits.empty?

    visit_date = self.daycare_visits.order(date: :asc).first.date
    return visit_date.strftime("%B %d, %Y") unless visit_date > Time.now
  end
end