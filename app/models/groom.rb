class Groom < ApplicationRecord
  belongs_to :pet
  belongs_to :user, foreign_key: 'employee_id', optional: true
  belongs_to :organisation
  has_many :images, dependent: :destroy
  has_one :log_report

  scope :today, -> { where(date: Time.zone.today) }
  scope :on_date, ->(date) { where(date: date) }
  scope :this_week, -> { where(date: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :in_future , -> { where("date > ?", Date.today) }

  scope :pending, -> { where(status: "pending")}
  scope :confirmed, -> { where(status: "confirmed")}
  scope :pending_or_confirmed, -> { pending.or(confirmed) }
  scope :in_progress, -> { where(status: "in_progress")}
  scope :completed, -> { where(status: "completed")}
  scope :missed_appointment, -> { where(status: "missed_appointment")}
  scope :missed_appointment_or_completed, -> { missed_appointment.or(completed) }

  enum :status, { pending: 0, confirmed: 1, in_progress: 2, completed: 3, missed_appointment: 4 }, default: :pending, prefix: :status
  enum :deposit_method, { cash: 0, card: 1, bank_transfer: 2, reward_points: 3 }, prefix: :deposit

  def service
    "Groom"
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
end