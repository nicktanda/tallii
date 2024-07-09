class Organisation < ApplicationRecord
  has_many :users
  has_many :pets
  has_many :onboarding_pets
  has_many :daycare_visits, dependent: :destroy
  has_many :grooms, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
end