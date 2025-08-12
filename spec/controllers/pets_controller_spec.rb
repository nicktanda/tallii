require 'rails_helper'

RSpec.describe PetsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet1) { create(:pet, user: customer, name: 'Fluffy') }
  let(:pet2) { create(:pet, user: customer, name: 'Rex') }
  let(:other_user) { create(:user, organisation: organisation) }
  let(:other_pet) { create(:pet, user: other_user) }
  let(:image1) { create(:image, user: customer, pet: pet1) }
  let(:image2) { create(:image, user: customer, pet: pet1) }

  before do
    sign_in_user(customer)
    set_current_pet(pet1)
    # Mock file uploads
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_call_original
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(nil)
  end

  describe 'GET #show' do
    it 'assigns the pet' do
      get :show, params: { id: pet1.id }
      expect(assigns(:pet)).to eq(pet1)
    end

    it 'renders successfully' do
      get :show, params: { id: pet1.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error when trying to access other user pet' do
      expect {
        get :show, params: { id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #pictures' do
    before do
      allow(pet1).to receive(:images).and_return([image1, image2])
      allow(customer).to receive(:pets).and_return(double(find: pet1))
    end

    it 'assigns the pet and its images' do
      get :pictures, params: { id: pet1.id }
      expect(assigns(:pet)).to eq(pet1)
      expect(assigns(:images)).to match_array([image1, image2])
    end

    it 'renders successfully' do
      get :pictures, params: { id: pet1.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error when trying to access other user pet' do
      expect {
        get :pictures, params: { id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) do
      {
        id: pet1.id,
        pet: {
          name: 'Updated Name',
          species: 'dog',
          gender: 'male',
          breed: 'Golden Retriever'
        }
      }
    end

    let(:invalid_params) do
      {
        id: pet1.id,
        pet: {
          name: nil
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the pet' do
        expect(pet1.name).to eq('Fluffy')
        expect(pet1.breed).to eq('Golden Retriever')

        patch :update, params: valid_params

        pet1.reload
        expect(pet1.name).to eq('Updated Name')
        expect(pet1.breed).to eq('Golden Retriever')
      end

      it 'redirects to pet profiles path with notice' do
        patch :update, params: valid_params
        expect(response).to redirect_to(pet_profiles_path)
        expect(flash[:notice]).to eq('Pet updated successfully')
      end

      context 'when image is provided' do
        let(:params_with_image) do
          valid_params.merge(pet: valid_params[:pet].merge(image: 'fake_image'))
        end

        before do
          allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return('fake_image')
        end

        it 'creates an image for the pet' do
          expect_any_instance_of(Pet).to receive_message_chain(:images, :create!).with(name: "test_image", image: 'fake_image')
          patch :update, params: params_with_image
        end
      end

      context 'when no image is provided' do
        it 'does not create an image' do
          expect_any_instance_of(Pet).not_to receive(:images)
          patch :update, params: valid_params
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not update the pet' do
        allow_any_instance_of(Pet).to receive(:save).and_return(false)
        original_species = pet1.species
        patch :update, params: invalid_params
        pet1.reload
        expect(pet1.species).to eq(original_species)
      end

      it 'redirects back with alert' do
        allow_any_instance_of(Pet).to receive(:save).and_return(false)
        patch :update, params: invalid_params
        expect(response).to redirect_to(new_pet_onboarding_path)
        expect(flash[:alert]).to eq('Invalid pet information')
      end
    end

    it 'raises error when trying to update other user pet' do
      expect {
        patch :update, params: { id: other_pet.id, pet: { name: 'test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #upload_new_image' do
    let(:fake_image) { 'fake_image_data' }

    before do
      # Override the global mock for image params for these tests
      allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(fake_image)
    end

    it 'creates a new image for the pet' do
      expect_any_instance_of(Pet).to receive_message_chain(:images, :create!).with(name: "test_image", image: fake_image)
      post :upload_new_image, params: { id: pet1.id, image: fake_image }
    end

    it 'redirects to pet pictures path with notice' do
      allow_any_instance_of(Pet).to receive_message_chain(:images, :create!)
      post :upload_new_image, params: { id: pet1.id, image: fake_image }
      expect(response).to redirect_to(pet_pictures_path(pet1))
      expect(flash[:notice]).to eq('Image uploaded')
    end

    it 'raises error when trying to upload to other user pet' do
      expect {
        post :upload_new_image, params: { id: other_pet.id, image: fake_image }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when image creation fails' do
      before do
        allow_any_instance_of(Pet).to receive_message_chain(:images, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        expect {
          post :upload_new_image, params: { id: pet1.id, image: fake_image }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'DELETE #delete_image' do
    before do
      # Ensure pet1 has multiple images by creating both
      image1 # This creates the first image
      image2 # This creates the second image
    end

    context 'when pet has more than one image' do
      it 'destroys the image' do
        expect {
          delete :delete_image, params: { id: pet1.id, image_id: image1.id }
        }.to change { pet1.reload.images.count }.by(-1)
      end

      it 'redirects to pet pictures with success notice' do
        delete :delete_image, params: { id: pet1.id, image_id: image1.id }
        expect(response).to redirect_to(pet_pictures_path(pet1))
        expect(flash[:notice]).to eq('Image deleted')
      end
    end

    context 'when pet has only one image' do
      before do
        # Remove the second image so pet only has one
        image2.destroy if image2.persisted?
      end

      it 'does not destroy the image' do
        expect {
          delete :delete_image, params: { id: pet1.id, image_id: image1.id }
        }.not_to change { pet1.reload.images.count }
      end

      it 'redirects with notice about minimum photos' do
        delete :delete_image, params: { id: pet1.id, image_id: image1.id }
        expect(response).to redirect_to(pet_pictures_path(pet1))
        expect(flash[:notice]).to eq('Pet needs to always have at least 1 photo')
      end
    end

    it 'raises error when trying to delete from other user pet' do
      expect {
        delete :delete_image, params: { id: other_pet.id, image_id: image1.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'DELETE #delete' do
    it 'destroys the pet' do
      pet_id = pet1.id
      delete :delete, params: { id: pet_id }
      expect { Pet.find(pet_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to pet profiles path with notice' do
      delete :delete, params: { id: pet1.id }
      expect(response).to redirect_to(pet_profiles_path)
      expect(flash[:notice]).to eq('Pet deleted successfully')
    end

    it 'raises error when trying to delete other user pet' do
      expect {
        delete :delete, params: { id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #current_pet_profile' do
    context 'when current pet exists' do
      it 'assigns the current pet' do
        get :current_pet_profile
        expect(assigns(:pet)).to eq(pet1)
      end

      it 'renders the show template' do
        get :current_pet_profile
        expect(response).to render_template(:show)
      end
    end

    context 'when no current pet is set' do
      before { session.delete(:current_pet) }

      it 'redirects to new pet onboarding path' do
        get :current_pet_profile
        expect(response).to redirect_to(new_pet_onboarding_path)
      end
    end
  end
end