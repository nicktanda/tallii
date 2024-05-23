class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :categories, dependent: :destroy
end