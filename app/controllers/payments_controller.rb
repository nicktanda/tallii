class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_authenticated_user, only: [:webhook]

  def pay
    @order = Order.find(params[:id])

    if @order.payment_intent_id
      payment_intent = get_payment_intent
    else
      payment_intent = create_payment_intent
      @order.update(payment_intent_id: payment_intent.id)
    end

    @payment_intent_client_secret = payment_intent.client_secret
  end

  def webhook
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Event.construct_from(
        JSON.parse(payload, symbolize_names: true)
      )
    rescue JSON::ParserError => e
      render plain: "Webhook error while parsing basic request. #{e.message}", status: 400
      return
    end

    endpoint_secret = "whsec_4c61fca30acf2d79b8f4b12cffa3003bc623520b98b35e23d81371f8887689b4"
    if endpoint_secret
      signature = request.env['HTTP_STRIPE_SIGNATURE']
      begin
        event = Stripe::Webhook.construct_event(
          payload, signature, endpoint_secret
        )
      rescue Stripe::SignatureVerificationError => e
        render plain: "Webhook signature verification failed. #{e.message}", status: 400
        return
      end
    end

    payment_intent = event.data.object

    case event.type
    when "payment_intent.succeeded"
      handle_payment_intent_status(payment_intent, 'succeed')
    when "payment_intent.processing"
      handle_payment_intent_status(payment_intent, 'processing')
    when "payment_intent.payment_failed"
      handle_payment_intent_status(payment_intent, 'failed')
    end

    render plain: "Status updated", status: 200
  end

  private

  def create_payment_intent
    Stripe::PaymentIntent.create(
      amount: @order.total_price,
      currency: 'usd',
      automatic_payment_methods: {enabled: true},
      description: "Order #{@order.id}"
    )
  end

  def get_payment_intent
    Stripe::PaymentIntent.retrieve(@order.payment_intent_id)
  end

  def handle_payment_intent_status(payment_intent, status)
    @order = Order.find_by(payment_intent_id: payment_intent.id)
    @order.update(status: status)
  end
end