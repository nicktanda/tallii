class Product < ApplicationRecord
  has_many :images
  has_many :reviews
  belongs_to :category, optional: true
  belongs_to :organisation
end