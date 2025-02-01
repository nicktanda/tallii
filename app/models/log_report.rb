class LogReport < ApplicationRecord
  belongs_to :groom
  belongs_to :temporary_groom
  belongs_to :daycare_visit
  belongs_to :temporary_daycare_visit

  enum payment_method: { cash: 0, card: 0 }
end