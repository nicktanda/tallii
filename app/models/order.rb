class Order < ApplicationRecord
  belongs_to :organisation, dependent: :destroy
  belongs_to :user, dependent: :destroy
  has_many :product_order_joins, dependent: :destroy
  has_many :products, through: :product_order_joins

  enum status: [:pending, :processing, :failed, :succeed]

  def total_price
    (products.sum(:price) * 100).to_i # in cents
  end
end