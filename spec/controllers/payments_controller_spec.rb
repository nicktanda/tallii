require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer) }
  let(:order) { create(:order, user: customer, organisation: organisation) }

  before do
    sign_in_user(customer)
    set_current_pet(pet)
    # Mock Stripe calls
    allow(Stripe::PaymentIntent).to receive(:create).and_return(
      double(id: 'pi_test123', client_secret: 'pi_test123_secret_abc')
    )
    allow(Stripe::PaymentIntent).to receive(:retrieve).and_return(
      double(id: 'pi_test123', client_secret: 'pi_test123_secret_abc')
    )
  end

  describe 'GET #pay' do
    context 'when order has no payment intent' do
      it 'assigns the order' do
        get :pay, params: { id: order.id }
        expect(assigns(:order)).to eq(order)
      end

      it 'creates a new payment intent' do
        expect(Stripe::PaymentIntent).to receive(:create).with(
          amount: order.total_price,
          currency: 'usd',
          automatic_payment_methods: { enabled: true },
          description: "Order #{order.id}"
        )
        get :pay, params: { id: order.id }
      end

      it 'updates order with payment intent id' do
        get :pay, params: { id: order.id }
        order.reload
        expect(order.payment_intent_id).to eq('pi_test123')
      end

      it 'assigns payment intent client secret' do
        get :pay, params: { id: order.id }
        expect(assigns(:payment_intent_client_secret)).to eq('pi_test123_secret_abc')
      end

      it 'renders successfully' do
        get :pay, params: { id: order.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when order already has a payment intent' do
      before do
        order.update(payment_intent_id: 'pi_existing123')
      end

      it 'retrieves existing payment intent' do
        expect(Stripe::PaymentIntent).to receive(:retrieve).with('pi_existing123')
        get :pay, params: { id: order.id }
      end

      it 'does not update the order' do
        expect(order).not_to receive(:update)
        get :pay, params: { id: order.id }
      end

      it 'assigns payment intent client secret' do
        get :pay, params: { id: order.id }
        expect(assigns(:payment_intent_client_secret)).to eq('pi_test123_secret_abc')
      end
    end

    it 'raises error for non-existent order' do
      expect {
        get :pay, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #webhook' do
    let(:valid_payload) do
      {
        type: 'payment_intent.succeeded',
        data: {
          object: {
            id: 'pi_test123'
          }
        }
      }.to_json
    end

    let(:invalid_payload) { 'invalid json' }

    before do
      order.update(payment_intent_id: 'pi_test123')
      request.headers['HTTP_STRIPE_SIGNATURE'] = 'valid_signature'
      
      # Mock Stripe JSON parsing
      allow(Stripe::Event).to receive(:construct_from).and_return(
        double(
          type: 'payment_intent.succeeded',
          data: double(object: double(id: 'pi_test123'))
        )
      )
      
      # Mock Stripe webhook verification
      allow(Stripe::Webhook).to receive(:construct_event).and_return(
        double(
          type: 'payment_intent.succeeded',
          data: double(object: double(id: 'pi_test123'))
        )
      )
    end

    context 'with valid webhook payload' do
      it 'processes payment_intent.succeeded event' do
        request.headers['HTTP_STRIPE_SIGNATURE'] = 'valid_signature'
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: valid_payload
        
        order.reload
        expect(order.status).to eq('succeed')
        expect(response).to have_http_status(:success)
        expect(response.body).to eq('Status updated')
      end

      it 'processes payment_intent.processing event' do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          double(
            type: 'payment_intent.processing',
            data: double(object: double(id: 'pi_test123'))
          )
        )
        
        request.headers['HTTP_STRIPE_SIGNATURE'] = 'valid_signature'
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: valid_payload
        
        order.reload
        expect(order.status).to eq('processing')
      end

      it 'processes payment_intent.payment_failed event' do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          double(
            type: 'payment_intent.payment_failed',
            data: double(object: double(id: 'pi_test123'))
          )
        )
        
        request.headers['HTTP_STRIPE_SIGNATURE'] = 'valid_signature'
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: valid_payload
        
        order.reload
        expect(order.status).to eq('failed')
      end

      it 'ignores unknown event types' do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          double(
            type: 'unknown_event',
            data: double(object: double(id: 'pi_test123'))
          )
        )
        
        request.headers['HTTP_STRIPE_SIGNATURE'] = 'valid_signature'
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: valid_payload
        
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid JSON payload' do
      it 'returns 400 error for invalid JSON' do
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: invalid_payload
        
        expect(response).to have_http_status(400)
        expect(response.body).to include('Webhook error while parsing basic request')
      end
    end

    context 'with invalid signature' do
      it 'returns 400 error for signature verification failure' do
        # Mock successful JSON parsing but failed signature verification
        allow(Stripe::Event).to receive(:construct_from).and_return(
          double(type: 'payment_intent.succeeded', data: double(object: double(id: 'pi_test123')))
        )
        allow(Stripe::Webhook).to receive(:construct_event).and_raise(
          Stripe::SignatureVerificationError.new('Invalid signature', 'test')
        )
        
        request.headers['HTTP_STRIPE_SIGNATURE'] = 'invalid_signature'
        request.headers['CONTENT_TYPE'] = 'application/json'
        
        post :webhook, body: valid_payload
        
        expect(response).to have_http_status(400)
        expect(response.body).to include('Webhook signature verification failed')
      end
    end
  end
end