class TemporaryGroom < ApplicationRecord
  belongs_to :user, foreign_key: 'employee_id', optional: true
  belongs_to :organisation

  scope :today, -> { where(date: Time.zone.today) }
  scope :on_date, ->(date) { where(date: date) }
  scope :this_week, -> { where(date: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :in_future , -> { where("date > ?", Date.today) }

  scope :pending, -> { where(status: "pending")}
  scope :confirmed, -> { where(status: "confirmed")}
  scope :pending_or_confirmed, -> { pending.or(confirmed) }
  scope :in_progress, -> { where(status: "in_progress")}
  scope :completed, -> { where(status: "completed")}

  validate :groom_date_is_in_the_future, on: :create

  enum status: { pending: 0, confirmed: 1, in_progress: 2, completed: 3 }

  private

  def groom_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end