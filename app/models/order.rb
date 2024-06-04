class Order < ApplicationRecord
  has_many :products
  belongs_to :organisation, dependent: :destroy
  belongs_to :user, dependent: :destroy
end