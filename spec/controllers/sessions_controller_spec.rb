require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation, email: 'customer@test.com', role: 'customer') }
  let(:employee) { create(:user, :employee, organisation: organisation, email: 'employee@test.com', role: 'employee') }
  let(:pet) { create(:pet, user: customer) }

  before do
    # Mock authenticate method since it's likely using has_secure_password
    allow_any_instance_of(User).to receive(:authenticate) do |user, password|
      password == 'correct_password' ? user : false
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      it 'renders the new template' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is already authenticated' do
      before { sign_in_user(customer) }

      it 'redirects to current pet profile path' do
        get :new
        expect(response).to redirect_to(current_pet_profile_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is already authenticated' do
      before { sign_in_user(customer) }

      it 'redirects to current pet profile path' do
        post :create, params: { email: customer.email, password: 'correct_password' }
        expect(response).to redirect_to(current_pet_profile_path)
      end
    end

    context 'with valid credentials for customer' do
      it 'authenticates user and redirects to pet profile' do
        post :create, params: { email: customer.email, password: 'correct_password' }
        
        expect(session["user"]["id"]).to eq(customer.id)
        expect(response).to redirect_to(current_pet_profile_path)
      end

      it 'sets current pet if user has pets' do
        pet # ensure pet is created
        post :create, params: { email: customer.email, password: 'correct_password' }
        
        expect(session["current_pet"]).to eq(pet.id)
      end
    end

    context 'with valid credentials for employee' do
      it 'authenticates user and redirects to mobile app profile' do
        post :create, params: { email: employee.email, password: 'correct_password' }
        
        expect(session["user"]["id"]).to eq(employee.id)
        expect(response).to redirect_to(mobile_app_profile_path)
      end
    end

    context 'with invalid email' do
      it 'redirects back with error message' do
        post :create, params: { email: 'nonexistent@test.com', password: 'any_password' }
        
        expect(session["user"]).to be_nil
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end

    context 'with invalid password' do
      it 'redirects back with error message' do
        post :create, params: { email: customer.email, password: 'wrong_password' }
        
        expect(session["user"]).to be_nil
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end

    context 'when user exists but authenticate returns false' do
      it 'redirects back with error message' do
        allow_any_instance_of(User).to receive(:authenticate).and_return(false)
        
        post :create, params: { email: customer.email, password: 'any_password' }
        
        expect(session["user"]).to be_nil
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end

    context 'when user has no pets' do
      let(:user_without_pets) { create(:user, organisation: organisation, email: 'nopets@test.com', role: 'customer') }

      it 'does not set current_pet in session' do
        post :create, params: { email: user_without_pets.email, password: 'correct_password' }
        
        expect(session["current_pet"]).to be_nil
        expect(response).to redirect_to(current_pet_profile_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in_user(customer) }

    it 'clears user session and redirects to new session path' do
      delete :destroy
      
      expect(session[:user]).to be_nil
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe 'POST #set_current_pet' do
    before { sign_in_user(customer) }

    it 'sets the current pet in session and redirects' do
      post :set_current_pet, params: { id: pet.id }
      
      expect(session["current_pet"]).to eq(pet.id.to_s)
      expect(response).to redirect_to(current_pet_profile_path)
    end
  end
end