class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def create
    order = current_user.orders.create!(organisation_id: current_organisation.id)

    # Batch load all products in a single query
    product_ids = order_params.map { |p| p[:id] }
    products_by_id = Product.where(id: product_ids).index_by(&:id)

    # Prepare batch insert data and stock updates
    join_records = []
    stock_updates = []

    order_params.each do |product_data|
      product = products_by_id[product_data[:id].to_i]
      next unless product

      quantity = product_data[:stock].to_i
      quantity.times { join_records << { product_id: product.id, order_id: order.id } }
      stock_updates << { id: product.id, stock: product.stock - quantity }
    end

    # Batch insert all join records at once
    ProductOrderJoin.insert_all(join_records) if join_records.any?

    # Batch update product stock
    stock_updates.each do |update|
      Product.where(id: update[:id]).update_all(stock: update[:stock])
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