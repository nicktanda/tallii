class Product < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :reviews
  has_many :product_category_joins, dependent: :destroy
  has_many :categories, through: :product_category_joins
  belongs_to :organisation
  has_many :product_order_joins, dependent: :destroy
  has_many :orders, through: :product_order_joins
end