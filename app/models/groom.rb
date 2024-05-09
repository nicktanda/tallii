class Groom < ApplicationRecord
  belongs_to :pet
  validate :groom_date_is_in_the_future

  private

  def groom_date_is_in_the_future
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end