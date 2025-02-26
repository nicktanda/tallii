class Organisation < ApplicationRecord
  before_validation :generate_unique_code, on: :create

  validates :access_code, presence: true, uniqueness: true
  
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
    (self.grooms.today + self.temporary_grooms.today).count
  end
  
  def grooms_this_week_count
    (self.grooms.this_week + self.temporary_grooms.this_week).count
  end
  
  def daycare_visits_today_count
    (self.daycare_visits.today + self.temporary_daycare_visits.today).count
  end
  
  def daycare_visits_this_week_count
    (self.daycare_visits.this_week + self.temporary_daycare_visits.this_week).count
  end

  private

  def generate_unique_code
    self.access_code ||= loop do
      random_code = SecureRandom.alphanumeric(6)
      break random_code unless self.class.exists?(access_code: random_code)
    end
  end
end