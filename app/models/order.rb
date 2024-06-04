class Order < ApplicationRecord
  belongs_to :organisation, dependent: :destroy
  belongs_to :user, dependent: :destroy
  has_many :order_product_joins, dependent: :destroy
  has_many :products, through: :order_product_joins
end