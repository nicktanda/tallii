class DaycareVisit < ApplicationRecord
  belongs_to :pet
  belongs_to :user, foreign_key: 'employee_id'

  enum duration: { half_day: 0, full_day: 1 }
  enum status: { pending: 0, confirmed: 1, in_progress: 2, completed: 3 }

  scope :today, -> { where(date: Time.zone.today) }

  scope :pending, -> { where(status: "pending")}
  scope :confirmed, -> { where(status: "confirmed")}
  scope :pending_or_confirmed, -> { pending.or(confirmed) }
  scope :in_progress, -> { where(status: "in_progress")}
  scope :completed, -> { where(status: "completed")}

  validate :daycare_visit_date_is_in_the_future

  private

  def daycare_visit_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end