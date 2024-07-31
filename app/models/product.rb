class Product < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :reviews
  belongs_to :category, optional: true
  belongs_to :organisation
  has_many :product_order_joins, dependent: :destroy
  has_many :orders, through: :product_order_joins
end