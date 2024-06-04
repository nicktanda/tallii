class OrdersController < ApplicationController
  def create
    order = current_user.orders.create!

    order_params[:products].each do |product|
      order.order_product_joins.create!(product_id: product[:product_id], quantity: product[:quantity])
    end

    redirect_to pay_path(order)
  end

  def order_params
    params.require(:order).permit(products: [:product_id, :quantity])
  end
end