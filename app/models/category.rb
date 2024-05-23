class Category < ApplicationRecord
  belongs_to :organisation
  has_many :products
  has_many :images, dependent: :destroy
end