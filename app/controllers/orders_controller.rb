class OrdersController < ApplicationController
  def create
    order = current_user.orders.new(order_params)

    if order.save
      redirect_to root_path
    else
      redirect_back fallback_location: new_order_path, alert: 'Invalid order'
    end
  end

  def order_params
    params.require(:order).permit(products: [:product_id, :quantity])
  end
end