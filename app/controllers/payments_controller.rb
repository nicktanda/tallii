class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_authenticated_user, only: [:webhook]

  def pay
    @order = Order.find(params[:id])

    if @order.payment_intent_id

    end
  end

  def webhook

  end
end