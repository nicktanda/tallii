class Organisation < ApplicationRecord
  before_validation :generate_unique_code, on: :create
  before_validation :set_default_opening_hours, on: :create

  validates :access_code, presence: true, uniqueness: true

  serialize :opening_hours, coder: JSON

  DEFAULT_OPENING_HOURS = {
    "Monday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Tuesday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Wednesday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Thursday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Friday" => { "open" => "09:00", "close" => "17:00", "closed" => "false" },
    "Saturday" => { "open" => "09:00", "close" => "17:00", "closed" => "true" },
    "Sunday" => { "open" => "09:00", "close" => "17:00", "closed" => "true" }
  }.freeze

  has_many :users
  has_many :pets
  has_many :onboarding_pets, dependent: :destroy
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :temporary_daycare_visits, dependent: :destroy
  has_many :temporary_grooms, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  def grooms_today_count
    grooms.today.count + temporary_grooms.today.count
  end

  def grooms_this_week_count
    grooms.this_week.count + temporary_grooms.this_week.count
  end

  def daycare_visits_today_count
    daycare_visits.today.count + temporary_daycare_visits.today.count
  end

  def daycare_visits_this_week_count
    daycare_visits.this_week.count + temporary_daycare_visits.this_week.count
  end

  private

  def generate_unique_code
    self.access_code ||= loop do
      random_code = SecureRandom.alphanumeric(6)
      break random_code unless self.class.exists?(access_code: random_code)
    end
  end

  def set_default_opening_hours
    self.opening_hours ||= DEFAULT_OPENING_HOURS.deep_dup
  end
end