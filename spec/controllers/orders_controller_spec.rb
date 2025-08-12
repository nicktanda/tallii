require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer) }
  let(:product1) { create(:product, organisation: organisation, price: 10.00, stock: 50) }
  let(:product2) { create(:product, organisation: organisation, price: 20.00, stock: 30) }
  let!(:order1) { create(:order, user: customer, organisation: organisation) }
  let!(:order2) { create(:order, user: customer, organisation: organisation) }

  before do
    sign_in_user(customer)
    set_current_pet(pet)
  end

  describe 'GET #index' do
    it 'assigns user orders' do
      get :index
      expect(assigns(:orders)).to match_array([order1, order2])
    end

    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'only shows orders for current user' do
      other_user = create(:user, organisation: organisation)
      other_order = create(:order, user: other_user, organisation: organisation)
      
      get :index
      expect(assigns(:orders)).not_to include(other_order)
    end
  end

  describe 'POST #create' do
    let(:valid_order_params) do
      {
        order: [
          { id: product1.id, stock: '2' },
          { id: product2.id, stock: '1' }
        ]
      }
    end

    before do
      session["user"]["cart"] = ["#{product1.id}", "#{product2.id}"]
    end

    context 'with valid parameters' do
      it 'creates a new order' do
        expect {
          post :create, params: valid_order_params
        }.to change(Order, :count).by(1)
      end

      it 'assigns the order to current user and organisation' do
        post :create, params: valid_order_params
        created_order = Order.last
        expect(created_order.user).to eq(customer)
        expect(created_order.organisation).to eq(organisation)
      end

      it 'creates product order joins for each item' do
        expect {
          post :create, params: valid_order_params
        }.to change(ProductOrderJoin, :count).by(3) # 2 for product1 + 1 for product2
      end

      it 'updates product stock' do
        original_stock1 = product1.stock
        original_stock2 = product2.stock
        
        post :create, params: valid_order_params
        
        product1.reload
        product2.reload
        
        expect(product1.stock).to eq(original_stock1 - 2)
        expect(product2.stock).to eq(original_stock2 - 1)
      end

      it 'clears the cart from session' do
        post :create, params: valid_order_params
        expect(session["user"]["cart"]).to be_nil
      end

      it 'redirects to payment page' do
        post :create, params: valid_order_params
        created_order = Order.last
        expect(response).to redirect_to(pay_path(created_order))
      end
    end

    context 'when product does not exist' do
      let(:invalid_order_params) do
        {
          order: [
            { id: 999999, stock: '1' }
          ]
        }
      end

      it 'raises an error' do
        expect {
          post :create, params: invalid_order_params
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when trying to order more stock than available' do
      let(:excessive_order_params) do
        {
          order: [
            { id: product1.id, stock: '100' }
          ]
        }
      end

      it 'still processes the order and sets negative stock' do
        post :create, params: excessive_order_params
        product1.reload
        expect(product1.stock).to be < 0
      end
    end

    context 'when order creation fails' do
      before do
        allow_any_instance_of(User).to receive_message_chain(:orders, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        expect {
          post :create, params: valid_order_params
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when product order join creation fails' do
      before do
        allow_any_instance_of(Order).to receive_message_chain(:product_order_joins, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        expect {
          post :create, params: valid_order_params
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end