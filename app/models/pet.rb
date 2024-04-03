class Pet < ApplicationRecord

  belongs_to :organisation
  belongs_to :user
  has_many :daycare_visits, dependent: :destroy
end