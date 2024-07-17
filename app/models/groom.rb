class Groom < ApplicationRecord
  belongs_to :pet

  scope :today, -> { where(date: Time.zone.today) }
  scope :on_date, ->(date) { where(date: date) }

  validate :groom_date_is_in_the_future

  enum status: { pending: 0, confirmed: 1, completed: 2 }

  private

  def groom_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end