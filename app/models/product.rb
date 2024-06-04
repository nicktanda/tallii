class Product < ApplicationRecord
  has_many :images
  has_many :reviews
  belongs_to :category, optional: true
  belongs_to :organisation
  has_many :order_product_joins
  has_many :orders, through: :order_product_joins
end