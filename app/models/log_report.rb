class LogReport < ApplicationRecord
  belongs_to :groom, optional: true
  belongs_to :temporary_groom, optional: true
  belongs_to :daycare_visit, optional: true
  belongs_to :temporary_daycare_visit, optional: true

  enum payment_method: { cash: 0, card: 1 }
end