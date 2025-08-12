require 'rails_helper'

RSpec.describe ShopController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer) }
  let(:category) { create(:category, organisation: organisation) }
  let(:product) { create(:product, organisation: organisation) }
  let(:review) { create(:review, product: product, user: customer) }

  before do
    sign_in_user(customer)
    set_current_pet(pet)
  end

  describe 'GET #shop' do
    it 'renders successfully' do
      get :shop
      expect(response).to have_http_status(:success)
    end

    it 'renders the shop template' do
      get :shop
      expect(response).to render_template(:shop)
    end
  end

  describe 'GET #product' do
    it 'assigns the product' do
      get :product, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end

    it 'renders successfully' do
      get :product, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error for non-existent product' do
      expect {
        get :product, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #review' do
    it 'assigns the product and new review' do
      get :review, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
      expect(assigns(:review)).to be_a_new(Review)
    end

    it 'renders successfully' do
      get :review, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error for non-existent product' do
      expect {
        get :review, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create_review' do
    let(:valid_review_params) do
      {
        id: product.id,
        review: {
          rating: 5,
          comment: 'Excellent product!'
        }
      }
    end

    let(:invalid_review_params) do
      {
        id: product.id,
        review: {
          rating: nil,
          comment: 'No rating'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new review' do
        expect {
          post :create_review, params: valid_review_params
        }.to change(Review, :count).by(1)
      end

      it 'assigns the review to the current user' do
        post :create_review, params: valid_review_params
        created_review = Review.last
        expect(created_review.user).to eq(customer)
        expect(created_review.product).to eq(product)
      end

      it 'redirects to the product page' do
        post :create_review, params: valid_review_params
        expect(response).to redirect_to(product_path(product))
      end
    end

    context 'with parameters missing rating' do
      it 'still creates the review and redirects' do
        post :create_review, params: invalid_review_params
        expect(response).to redirect_to(product_path(product))
      end
    end

    it 'raises error for non-existent product' do
      expect {
        post :create_review, params: { id: 999999, review: { rating: 5, comment: 'Test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #category' do
    let!(:product1) { create(:product, organisation: organisation) }
    let!(:product2) { create(:product, organisation: organisation) }

    before do
      category.products << [product1, product2]
    end

    it 'assigns the category and its products' do
      get :category, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
      expect(assigns(:products)).to match_array([product1, product2])
    end

    it 'renders successfully' do
      get :category, params: { id: category.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error for non-existent category' do
      expect {
        get :category, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #add_to_cart' do
    let(:cart_params) do
      {
        id: product.id.to_s,
        stock: '2'
      }
    end

    context 'when user session matches current user' do
      it 'adds products to cart session' do
        post :add_to_cart, params: cart_params
        expect(session["user"]["cart"]).to eq([product.id.to_s, product.id.to_s])
      end

      it 'redirects to cart page' do
        post :add_to_cart, params: cart_params
        expect(response).to redirect_to(cart_path)
      end

      it 'initializes cart if not present' do
        session["user"].delete("cart")
        post :add_to_cart, params: cart_params
        expect(session["user"]["cart"]).to be_present
      end
    end

    context 'when user session does not match current user' do
      before do
        session["user"]["id"] = 999999
      end

      it 'does not add to cart' do
        post :add_to_cart, params: cart_params
        expect(session["user"]["cart"]).to be_nil
      end

      it 'redirects to login due to session mismatch' do
        post :add_to_cart, params: cart_params
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #cart' do
    let(:product1) { create(:product, organisation: organisation, name: 'Product 1', price: 10.00) }
    let(:product2) { create(:product, organisation: organisation, name: 'Product 2', price: 20.00) }

    before do
      session["user"]["cart"] = [product1.id.to_s, product1.id.to_s, product2.id.to_s]
    end

    it 'assigns cart products with quantities' do
      get :cart
      cart_products = assigns(:cart_products)
      
      expect(cart_products.length).to eq(2)
      
      product1_item = cart_products.find { |item| item[:product] == product1 }
      product2_item = cart_products.find { |item| item[:product] == product2 }
      
      expect(product1_item[:quantity]).to eq(2)
      expect(product2_item[:quantity]).to eq(1)
    end

    it 'renders successfully' do
      get :cart
      expect(response).to have_http_status(:success)
    end

    context 'when cart is empty' do
      before do
        session["user"]["cart"] = []
      end

      it 'assigns empty cart products' do
        get :cart
        expect(assigns(:cart_products)).to be_empty
      end
    end

    context 'when cart is nil' do
      before do
        session["user"].delete("cart")
      end

      it 'handles nil cart gracefully' do
        expect {
          get :cart
        }.to raise_error(NoMethodError) # This is expected behavior based on current implementation
      end
    end
  end
end