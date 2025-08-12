require 'rails_helper'

RSpec.describe Desktop::PetsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer, organisation_id: organisation.id) }
  let(:image1) { create(:image, user: customer, pet: pet) }
  let(:image2) { create(:image, user: customer, pet: pet) }

  before do
    sign_in_user(employee)
    # Mock Active Storage attachments
    allow_any_instance_of(Pet).to receive(:rabies_evidence).and_return(double(attached?: false))
    allow_any_instance_of(Pet).to receive(:bordetella_evidence).and_return(double(attached?: false))
    allow_any_instance_of(Pet).to receive(:dhpp_evidence).and_return(double(attached?: false))
    allow_any_instance_of(Pet).to receive(:heartworm_evidence).and_return(double(attached?: false))
    allow_any_instance_of(Pet).to receive(:kennel_cough_evidence).and_return(double(attached?: false))
    # Mock file uploads
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_call_original
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(nil)
  end

  describe 'GET #show' do
    it 'assigns the pet' do
      get :show, params: { id: pet.id }
      expect(assigns(:pet)).to eq(pet)
    end

    it 'renders successfully' do
      get :show, params: { id: pet.id }
      expect(response).to have_http_status(:success)
    end

    it 'uses joins to include user data' do
      expect_any_instance_of(ActiveRecord::AssociationRelation).to receive(:joins).with(:user).and_call_original
      get :show, params: { id: pet.id }
    end

    it 'raises error for pet from different organisation' do
      other_org = create(:organisation)
      other_user = create(:user, organisation: other_org)
      other_pet = create(:pet, user: other_user)

      expect {
        get :show, params: { id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #pictures' do
    before do
      allow(pet).to receive(:images).and_return([image1, image2])
    end

    it 'assigns the pet and its images' do
      get :pictures, params: { id: pet.id }
      expect(assigns(:pet)).to eq(pet)
      expect(assigns(:images)).to match_array([image1, image2])
    end

    it 'renders successfully' do
      get :pictures, params: { id: pet.id }
      expect(response).to have_http_status(:success)
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
      post :upload_new_image, params: { id: pet.id, image: fake_image }
    end

    it 'redirects to pet pictures path with notice' do
      allow_any_instance_of(Pet).to receive_message_chain(:images, :create!)
      post :upload_new_image, params: { id: pet.id, image: fake_image }
      expect(response).to redirect_to(desktop_pets_pictures_path(pet))
      expect(flash[:notice]).to eq('Image uploaded')
    end

    it 'raises error for pet from different organisation' do
      other_org = create(:organisation)
      other_user = create(:user, organisation: other_org)
      other_pet = create(:pet, user: other_user)

      expect {
        post :upload_new_image, params: { id: other_pet.id, image: fake_image }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'DELETE #delete_pet_picture' do
    context 'when pet has more than one image' do
      it 'destroys the image' do
        # Ensure images are loaded first
        image1
        image2
        expect {
          delete :delete_pet_picture, params: { id: pet.id, image_id: image1.id }
        }.to change { Pet.find(pet.id).images.count }.by(-1)
        expect(Image.find_by(id: image1.id)).to be_nil
      end

      it 'redirects to pet pictures with success notice' do
        # Ensure images are loaded first
        image1
        image2
        allow(image1).to receive(:destroy)
        delete :delete_pet_picture, params: { id: pet.id, image_id: image1.id }
        expect(response).to redirect_to(desktop_pets_pictures_path(pet))
        expect(flash[:notice]).to eq('Image deleted')
      end
    end

    context 'when pet has only one image' do
      before do
        allow(pet).to receive(:images).and_return(double(find: image1, count: 1))
      end

      it 'does not destroy the image' do
        expect(image1).not_to receive(:destroy)
        delete :delete_pet_picture, params: { id: pet.id, image_id: image1.id }
      end

      it 'redirects with notice about minimum photos' do
        delete :delete_pet_picture, params: { id: pet.id, image_id: image1.id }
        expect(response).to redirect_to(desktop_pets_pictures_path(pet))
        expect(flash[:notice]).to eq('Pet needs to always have at least 1 photo')
      end
    end
  end

  describe 'GET #new' do
    it 'assigns the user' do
      get :new, params: { id: customer.id }
      expect(assigns(:user)).to eq(customer)
    end

    it 'renders successfully' do
      get :new, params: { id: customer.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error for user from different organisation' do
      other_org = create(:organisation)
      other_user = create(:user, organisation: other_org)

      expect {
        get :new, params: { id: other_user.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        pet: {
          user_id: customer.id,
          name: 'New Pet',
          species: 'dog',
          gender: 'male',
          breed: 'Golden Retriever',
          dob: 2.years.ago.to_date,
          health_conditions: 'None',
          weight: 50
        }
      }
    end

    let(:invalid_params) do
      {
        pet: {
          user_id: customer.id,
          name: 'Test Pet',
          dob: Date.today + 1.day,
          breed: 'Test Breed',
          health_conditions: 'None', 
          weight: 10
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new pet' do
        expect {
          post :create, params: valid_params
        }.to change(Pet, :count).by(1)
      end

      it 'assigns pet to the correct user and organisation' do
        post :create, params: valid_params
        created_pet = Pet.last
        expect(created_pet.user).to eq(customer)
        expect(created_pet.organisation_id).to eq(organisation.id)
      end

      it 'redirects to desktop user edit path with notice' do
        post :create, params: valid_params
        expect(response).to redirect_to(desktop_user_edit_path(customer))
        expect(flash[:notice]).to eq('Pet updated successfully')
      end

      context 'when image is provided' do
        let(:params_with_image) do
          valid_params.merge(pet: valid_params[:pet].merge(image: 'fake_image'))
        end

        before do
          # Override the global mock to allow pet image params through
          allow(controller).to receive(:params).and_return(ActionController::Parameters.new(params_with_image))
        end

        it 'creates an image for the pet' do
          allow_any_instance_of(Pet).to receive_message_chain(:images, :create!).and_return(true)
          post :create, params: params_with_image
          expect(response).to redirect_to(desktop_user_edit_path(customer))
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not create a pet' do
        # Mock the save to fail since Pet model has minimal validations
        allow_any_instance_of(Pet).to receive(:save).and_return(false)
        expect {
          post :create, params: invalid_params
        }.not_to change(Pet, :count)
      end

      it 'redirects back with alert' do
        # Mock the save to fail since Pet model has minimal validations
        allow_any_instance_of(Pet).to receive(:save).and_return(false)
        post :create, params: invalid_params
        expect(response).to redirect_to(desktop_user_edit_path(customer))
        expect(flash[:alert]).to eq('Invalid pet information')
      end
    end

    it 'raises error for user from different organisation' do
      other_org = create(:organisation)
      other_user = create(:user, organisation: other_org)
      invalid_org_params = valid_params.merge(pet: { user_id: other_user.id, name: 'Test' })

      expect {
        post :create, params: invalid_org_params
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) do
      {
        id: pet.id,
        pet: {
          name: 'Updated Name',
          breed: 'Updated Breed',
          colour_codes: ['easy', 'senior']
        }
      }
    end

    let(:invalid_params) do
      {
        id: pet.id,
        pet: {
          name: nil,
          breed: nil
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the pet' do
        patch :update, params: valid_params
        pet.reload
        expect(pet.name).to eq('Updated Name')
        expect(pet.breed).to eq('Updated Breed')
      end

      it 'updates colour codes' do
        patch :update, params: valid_params
        pet.reload
        expect(pet.colour_codes).to eq(['easy', 'senior'])
      end

      context 'when pet is alive' do
        before { allow(pet).to receive(:alive?).and_return(true) }

        it 'redirects to desktop pets path with notice' do
          patch :update, params: valid_params
          expect(response).to redirect_to(desktop_pets_path(pet))
          expect(flash[:notice]).to eq('Pet updated successfully')
        end
      end

      context 'when pet is not alive' do
        before { allow_any_instance_of(Pet).to receive(:alive?).and_return(false) }

        it 'redirects to desktop user path with notice' do
          patch :update, params: valid_params
          expect(response).to redirect_to(desktop_user_path(pet.user))
          expect(flash[:notice]).to eq('Pet updated successfully')
        end
      end
    end

    context 'with invalid parameters' do
      before do
        allow_any_instance_of(Pet).to receive(:save).and_return(false)
      end

      it 'does not update the pet' do
        original_name = pet.name
        patch :update, params: valid_params.merge(pet: { name: 'Should not save' })
        pet.reload
        expect(pet.name).to eq(original_name)
      end

      it 'redirects back with alert' do
        patch :update, params: valid_params.merge(pet: { name: 'Should not save' })
        expect(response).to redirect_to(desktop_pets_path(pet))
        expect(flash[:alert]).to eq('Invalid pet information')
      end
    end
  end

  describe 'DELETE #delete' do
    it 'destroys the pet' do
      pet_id = pet.id
      delete :delete, params: { id: pet_id }
      expect { Pet.find(pet_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to desktop user path' do
      user = pet.user
      delete :delete, params: { id: pet.id }
      expect(response).to redirect_to(desktop_user_path(user))
    end
  end

  describe 'medical evidence download actions' do
    let(:fake_blob_url) { '/rails/active_storage/blobs/fake-key/file.pdf' }

    before do
      allow(controller).to receive(:rails_blob_url).and_return(fake_blob_url)
    end

    %w[rabies bordetella dhpp heartworm kennel_cough].each do |evidence_type|
      describe "GET #download_#{evidence_type}_evidence" do
        context 'when evidence is attached' do
          before do
            evidence_method = "#{evidence_type}_evidence"
            allow_any_instance_of(Pet).to receive(evidence_method).and_return(double(attached?: true))
          end

          it 'redirects to the file URL' do
            # Mock the rails_blob_url to return expected URL with disposition
            expect(controller).to receive(:rails_blob_url).with(anything, disposition: "attachment").and_return(fake_blob_url)
            get "download_#{evidence_type}_evidence".to_sym, params: { id: pet.id }
            expect(response).to redirect_to(fake_blob_url)
          end
        end

        context 'when evidence is not attached' do
          it 'redirects back with alert' do
            get "download_#{evidence_type}_evidence".to_sym, params: { id: pet.id }
            expect(response).to redirect_to(desktop_pets_path(pet))
            expect(flash[:alert]).to eq('File not found.')
          end
        end

        it 'raises error for non-existent pet' do
          expect {
            get "download_#{evidence_type}_evidence".to_sym, params: { id: 999999 }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end