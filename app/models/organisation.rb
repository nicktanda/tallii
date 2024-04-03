class Organisation < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :pets, dependent: :destroy
end