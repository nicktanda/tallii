require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet1) { create(:pet, user: customer) }
  let(:pet2) { create(:pet, user: customer) }
  let(:other_user) { create(:user, organisation: organisation) }
  let(:other_pet) { create(:pet, user: other_user) }

  before do
    sign_in_user(customer)
    set_current_pet(pet1)
  end

  describe 'GET #index' do
    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #pet_profiles' do
    it 'renders successfully' do
      get :pet_profiles
      expect(response).to have_http_status(:success)
    end

    it 'renders the pet_profiles template' do
      get :pet_profiles
      expect(response).to render_template(:pet_profiles)
    end
  end

  describe 'GET #pet_profile' do
    it 'assigns the pet' do
      get :pet_profile, params: { id: pet1.id }
      expect(assigns(:pet)).to eq(pet1)
    end

    it 'renders successfully' do
      get :pet_profile, params: { id: pet1.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the pet_profile template' do
      get :pet_profile, params: { id: pet1.id }
      expect(response).to render_template(:pet_profile)
    end

    it 'raises error for non-existent pet' do
      expect {
        get :pet_profile, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'allows access to own pets' do
      get :pet_profile, params: { id: pet2.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:pet)).to eq(pet2)
    end

    it 'prevents access to other users pets' do
      expect {
        get :pet_profile, params: { id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #pet_selection' do
    it 'renders successfully' do
      get :pet_selection
      expect(response).to have_http_status(:success)
    end

    it 'renders the pet_selection template' do
      get :pet_selection
      expect(response).to render_template(:pet_selection)
    end
  end

  describe 'GET #user_profile' do
    it 'renders successfully' do
      get :user_profile
      expect(response).to have_http_status(:success)
    end

    it 'renders the user_profile template' do
      get :user_profile
      expect(response).to render_template(:user_profile)
    end
  end

  describe 'GET #update_user_profile' do
    it 'raises template missing error since action is empty and template does not exist' do
      expect {
        get :update_user_profile
      }.to raise_error(ActionController::MissingExactTemplate)
    end
  end
end