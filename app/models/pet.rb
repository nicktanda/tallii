class Pet < ApplicationRecord
  belongs_to :user
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :images, dependent: :destroy

  has_one_attached :rabies_evidence
  has_one_attached :bordetella_evidence
  has_one_attached :dhpp_evidence
  has_one_attached :heartworm_evidence
  has_one_attached :kennel_cough_evidence

  enum status: { active: 0, inactive: 1, deceased: 6 }
  enum species: { dog: 0, cat: 1, other: 6 }
  enum gender: { male: 0, female: 1 }

  scope :alive, -> { where("date_of_death > ? OR date_of_death IS NULL", Date.today) }
  default_scope { alive }

  def size
    case weight
    when 0..25
      "Small"
    when 26..50
      "Medium"
    else
      "Large"
    end
  end

  def alive?
    self.date_of_death.nil? || self.date_of_death > Date.today
  end

  def age
    dob = self.dob
    now = Time.now.utc.to_date
    now.year - dob.year - (dob.to_date.change(year: now.year) > now ? 1 : 0)
  end

  def next_groom
    return if self.grooms.empty?

    groom_date = self.grooms.order(date: :asc).first.date
    groom_date.strftime("%B %d, %Y") unless groom_date < Time.now
  end

  def last_groom
    return if self.grooms.empty?

    groom_date = self.grooms.order(date: :desc).first.date
    groom_date.strftime("%B %d, %Y") unless groom_date > Time.now
  end

  def last_daycare_visit
    return if self.daycare_visits.empty?

    visit_date = self.daycare_visits.order(date: :desc).first.date
    visit_date.strftime("%B %d, %Y") unless visit_date > Time.now
  end

  def next_daycare_visit
    return if self.daycare_visits.empty?

    visit_date = self.daycare_visits.order(date: :asc).first.date
    visit_date.strftime("%B %d, %Y") unless visit_date < Time.now
  end

  def self.colour_code_options
    {
      easy: "Easy",
      helicopter: "Helicopter",
      selective: "People Obsessive / Selective",
      special_needs: "Special Needs",
      obsessive: "Obsessive Behaviour",
      senior: "Senior"
    }
  end

  def self.colours
    {
      easy: "bg-emerald-400",
      helicopter: "bg-teal-700",
      selective: "bg-teal-950",
      special_needs: "bg-violet-700",
      obsessive: "bg-amber-500",
      senior: "bg-red-700"
    }
  end
end