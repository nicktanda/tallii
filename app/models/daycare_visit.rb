class DaycareVisit < ApplicationRecord
  belongs_to :pet
  belongs_to :user, foreign_key: 'employee_id', optional: true
  belongs_to :organisation

  enum duration: { half_day: 0, full_day: 1 }
  enum status: { pending: 0, confirmed: 1, in_progress: 2, completed: 3, missed_appointment: 4 }

  scope :today, -> { where(date: Time.zone.today) }
  scope :on_date, ->(date) { where(date: date) }
  scope :in_future , -> { where("date > ?", Date.today) }
  scope :this_week, -> { where(date: Date.today.beginning_of_week..Date.today.end_of_week) }

  scope :pending, -> { where(status: "pending")}
  scope :confirmed, -> { where(status: "confirmed")}
  scope :pending_or_confirmed, -> { pending.or(confirmed) }
  scope :in_progress, -> { where(status: "in_progress")}
  scope :completed, -> { where(status: "completed")}
  scope :missed_appointment, -> { where(status: "missed_appointment")}
  scope :missed_appointment_or_completed, -> { missed_appointment.or(completed) }

  validate :daycare_visit_date_is_in_the_future, on: :create

  def formatted_duration
    case duration
    when 'half_day'
      'Half Day'
    when 'full_day'
      'Full Day'
    end
  end

  def service
    "Daycare Visit"
  end

  def notes?
    notes.present? ? "Yes" : "No"
  end

  def formatted_status
    case status
    when 'pending'
      'Pending'
    when 'confirmed'
      'Confirmed'
    when 'in_progress'
      'In Progress'
    when 'completed'
      'Completed'
    when 'missed_appointment'
      'Missed Appointment'
    end
  end

  private

  def daycare_visit_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end