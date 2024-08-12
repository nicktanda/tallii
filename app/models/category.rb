class Category < ApplicationRecord
  belongs_to :organisation
  has_many :product_category_joins, dependent: :destroy
  has_many :products, through: :product_category_joins
  has_many :images, dependent: :destroy
end