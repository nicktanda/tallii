class DaycareVisit < ApplicationRecord
  belongs_to :pet
  enum duration: { half_day: 0, full_day: 1 }

  scope :today, -> { where(date: Time.zone.today) }

  validate :daycare_visit_date_is_in_the_future

  private

  def daycare_visit_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end