class Order < ApplicationRecord
  belongs_to :organisation, dependent: :destroy
  belongs_to :user, dependent: :destroy
  has_many :product_order_joins, dependent: :destroy
  has_many :products, through: :product_order_joins

  scope :today, -> { where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day) }

  enum status: [:pending, :processing, :failed, :succeed]

  def total_price
    (products.sum(:price) * 100).to_i # in cents
  end

  def total_price_in_dollars
    total_price / 100.0
  end
end