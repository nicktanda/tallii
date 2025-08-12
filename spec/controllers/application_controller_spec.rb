require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Create a test controller to test ApplicationController methods
  controller do
    def index
      render plain: 'test'
    end

    def show
      render plain: 'test'
    end
  end

  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisation: organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation) }
  let(:pet) { create(:pet, user: user) }

  describe 'before_actions' do
    context 'when user is not authenticated' do
      it 'redirects to new session path' do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated but has no pet' do
      before { sign_in_user(user) }

      it 'redirects to new pet onboarding path' do
        get :index
        expect(response).to redirect_to(new_pet_onboarding_path)
      end
    end

    context 'when user is authenticated and has a pet' do
      before do
        sign_in_user(user)
        set_current_pet(pet)
      end

      it 'allows access to the action' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when desktop origin is specified' do
      before { sign_in_user(user) }

      it 'skips pet requirement for groom with desktop origin' do
        allow(controller).to receive(:params).and_return({ groom: { origin: 'desktop' } })
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'skips pet requirement for daycare_visit with desktop origin' do
        allow(controller).to receive(:params).and_return({ daycare_visit: { origin: 'desktop' } })
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#current_user' do
    context 'when user session exists' do
      before { session["user"] = { "id" => user.id } }

      it 'returns the current user' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when no user session exists' do
      it 'returns nil' do
        expect(controller.current_user).to be_nil
      end
    end

    context 'when user session exists but user is deleted' do
      before { session["user"] = { "id" => 999999 } }

      it 'returns nil' do
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe '#current_pet' do
    before { sign_in_user(user) }

    context 'when pet session exists and pet belongs to user' do
      before { session[:current_pet] = pet.id }

      it 'returns the current pet' do
        expect(controller.current_pet).to eq(pet)
      end
    end

    context 'when no pet session exists' do
      it 'returns nil' do
        expect(controller.current_pet).to be_nil
      end
    end

    context 'when pet session exists but pet does not belong to user' do
      let(:other_user) { create(:user, organisation: organisation) }
      let(:other_pet) { create(:pet, user: other_user) }
      
      before { session[:current_pet] = other_pet.id }

      it 'returns nil' do
        expect(controller.current_pet).to be_nil
      end
    end
  end

  describe '#current_organisation' do
    context 'when user is signed in' do
      before { sign_in_user(user) }

      it 'returns the user organisation' do
        expect(controller.current_organisation).to eq(organisation)
      end
    end

    context 'when no user is signed in' do
      it 'returns nil' do
        expect(controller.current_organisation).to be_nil
      end
    end
  end

  describe '#prevent_customer_accessing_desktop' do
    let(:customer) { create(:user, :customer, organisation: organisation, role: 'customer') }
    let(:customer_pet) { create(:pet, user: customer) }
    
    before do
      sign_in_user(customer)
      set_current_pet(customer_pet)
      allow(controller).to receive(:controller_path).and_return('desktop/users')
    end

    it 'redirects customer away from desktop paths' do
      get :index
      expect(response).to redirect_to(current_pet_profile_path)
    end

    context 'when user is an employee' do
      before do
        sign_in_user(employee)
        allow(controller).to receive(:controller_path).and_return('desktop/users')
      end

      it 'allows access to desktop paths' do
        # This would redirect due to no pet, but not due to customer restriction
        get :index
        expect(response).not_to redirect_to(current_pet_profile_path)
      end
    end
  end

  describe '#set_stripe_api_key' do
    before { sign_in_user(user) }

    context 'when organisation has stripe api key' do
      before do
        organisation.update!(stripe_api_key: 'test_key')
        set_current_pet(pet)
      end

      it 'sets the Stripe API key' do
        expect(Stripe).to receive(:api_key=).with('test_key')
        get :index
      end
    end

    context 'when organisation has no stripe api key' do
      before do
        organisation.update!(stripe_api_key: nil)
        set_current_pet(pet)
      end

      it 'sets empty string as Stripe API key' do
        expect(Stripe).to receive(:api_key=).with("")
        get :index
      end
    end

    context 'when no current organisation' do
      before do
        allow(controller).to receive(:current_organisation).and_return(nil)
      end

      it 'does not set Stripe API key' do
        expect(Stripe).not_to receive(:api_key=)
        get :index
      end
    end
  end
end