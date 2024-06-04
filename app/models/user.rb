class User < ApplicationRecord
  has_secure_password
  belongs_to :organisation

  has_many :reviews, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :orders, dependent: :destroy
end