class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def create
    order = current_user.orders.create!(organisation_id: current_organisation.id)

    order_params.each do |product|
      item = Product.find(product[:id])
      product[:stock].to_i.times do
        order.product_order_joins.create!(product_id: item.id)
      end
      item.update!(stock: item.stock - product[:stock].to_i)
    end

    session["user"].delete("cart")
    redirect_to pay_path(order)
  end

  private

  def order_params
    params.require(:order).map do |order|
      order.permit(:stock, :id).to_h.symbolize_keys
    end
  end
end