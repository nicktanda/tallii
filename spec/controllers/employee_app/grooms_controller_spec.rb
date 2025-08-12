require 'rails_helper'

RSpec.describe EmployeeApp::GroomsController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer) }
  let(:groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.today + 1.day, time: '09:00', status: 'pending') }
  let(:temp_groom) { create(:temporary_groom, organisation: organisation, user: employee, date: Date.today + 1.day, time: '10:00', status: 'pending') }
  let(:other_employee) { create(:user, :employee, organisation: organisation) }
  let(:other_groom) { create(:groom, pet: pet, organisation: organisation, user: other_employee) }

  before do
    sign_in_user(employee)
    # Mock file uploads
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_call_original
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(nil)
  end

  describe 'GET #index' do
    let!(:pending_groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.current, time: '09:00', status: 'pending') }
    let!(:confirmed_groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.current, time: '10:00', status: 'confirmed') }
    let!(:in_progress_groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.current, time: '11:00', status: 'in_progress') }
    let!(:completed_groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.current, time: '12:00', status: 'completed') }
    let!(:missed_groom) { create(:groom, pet: pet, organisation: organisation, user: employee, date: Date.current, time: '13:00', status: 'missed_appointment') }
    
    let!(:temp_pending_groom) { create(:temporary_groom, organisation: organisation, user: employee, date: Date.current, time: '14:00', status: 'pending') }
    let!(:temp_in_progress_groom) { create(:temporary_groom, organisation: organisation, user: employee, date: Date.current, time: '15:00', status: 'in_progress') }
    let!(:temp_completed_groom) { create(:temporary_groom, organisation: organisation, user: employee, date: Date.current, time: '16:00', status: 'completed') }

    it 'assigns pending and confirmed grooms for today for current employee' do
      get :index
      grooms = assigns(:grooms)
      expect(grooms).to include(pending_groom)
      expect(grooms).to include(confirmed_groom)
      expect(grooms).to include(temp_pending_groom)
      expect(grooms).not_to include(in_progress_groom)
      expect(grooms).not_to include(completed_groom)
    end

    it 'assigns in progress grooms for today for current employee' do
      get :index
      in_progress_grooms = assigns(:in_progress_grooms)
      expect(in_progress_grooms).to include(in_progress_groom)
      expect(in_progress_grooms).to include(temp_in_progress_groom)
      expect(in_progress_grooms).not_to include(pending_groom)
      expect(in_progress_grooms).not_to include(completed_groom)
    end

    it 'assigns completed and missed grooms for today for current employee' do
      get :index
      completed_grooms = assigns(:completed_grooms)
      expect(completed_grooms).to include(completed_groom)
      expect(completed_grooms).to include(missed_groom)
      expect(completed_grooms).to include(temp_completed_groom)
      expect(completed_grooms).not_to include(pending_groom)
      expect(completed_grooms).not_to include(in_progress_groom)
    end

    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'only shows grooms assigned to current employee' do
      get :index
      all_grooms = assigns(:grooms) + assigns(:in_progress_grooms) + assigns(:completed_grooms)
      expect(all_grooms).not_to include(other_groom)
    end
  end

  describe 'GET #show' do
    it 'assigns the groom' do
      get :show, params: { id: groom.id }
      expect(assigns(:groom)).to eq(groom)
    end

    it 'renders successfully' do
      get :show, params: { id: groom.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error when trying to access groom not assigned to current employee' do
      expect {
        get :show, params: { id: other_groom.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) do 
      {
        id: groom.id,
        groom: {
          notes: 'Updated notes',
          status: 'in_progress'
        }
      }
    end
    let(:invalid_params) do
      {
        id: groom.id,
        groom: { pet_id: nil }
      }
    end

    context 'with valid parameters' do
      it 'updates the groom' do
        patch :update, params: valid_params
        groom.reload
        expect(groom.notes).to eq('Updated notes')
        expect(groom.status).to eq('in_progress')
      end

      it 'redirects to employee app grooms path with notice' do
        patch :update, params: valid_params
        expect(response).to redirect_to(employee_app_grooms_path)
        expect(flash[:notice]).to eq('Groom updated successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the groom' do
        original_notes = groom.notes
        patch :update, params: invalid_params
        groom.reload
        expect(groom.notes).to eq(original_notes)
      end

      it 'redirects back with alert' do
        patch :update, params: invalid_params
        expect(response).to redirect_to(employee_app_groom_path(groom))
        expect(flash[:alert]).to eq('Invalid groom information')
      end
    end

    it 'raises error when trying to update groom not assigned to current employee' do
      expect {
        patch :update, params: { id: other_groom.id, groom: { notes: 'test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #images' do
    let(:image1) { create(:image, user: customer, groom: groom) }
    let(:image2) { create(:image, user: customer, groom: groom) }

    before do
      allow(organisation).to receive(:grooms).and_return(double(find: groom))
      allow(groom).to receive(:images).and_return([image1, image2])
    end

    it 'assigns the groom and its images' do
      get :images, params: { id: groom.id }
      expect(assigns(:groom)).to eq(groom)
      expect(assigns(:images)).to match_array([image1, image2])
    end

    it 'renders successfully' do
      get :images, params: { id: groom.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #upload_image' do
    let(:fake_image) { 'fake_image_data' }

    before do
      allow(organisation).to receive(:grooms).and_return(double(find: groom))
      # Override the global mock for image params for these tests
      allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(fake_image)
    end

    it 'creates a new image for the groom' do
      expect_any_instance_of(Groom).to receive_message_chain(:images, :create!).with(name: "test_image", image: fake_image)
      post :upload_image, params: { id: groom.id, image: fake_image }
    end

    it 'redirects to groom images path with notice' do
      allow_any_instance_of(Groom).to receive_message_chain(:images, :create!)
      post :upload_image, params: { id: groom.id, image: fake_image }
      expect(response).to redirect_to(employee_app_groom_images_path(groom))
      expect(flash[:notice]).to eq('Image uploaded')
    end

    context 'when image creation fails' do
      before do
        allow_any_instance_of(Groom).to receive_message_chain(:images, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        expect {
          post :upload_image, params: { id: groom.id, image: fake_image }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'DELETE #destroy_image' do
    let(:image1) { create(:image, user: customer, groom: groom) }
    let(:image2) { create(:image, user: customer, groom: groom) }

    before do
      # Ensure both images exist first
      image1
      image2
    end

    context 'when groom has more than one image' do
      it 'destroys the image' do
        expect {
          delete :destroy_image, params: { id: groom.id, image_id: image1.id }
        }.to change { groom.reload.images.count }.by(-1)
      end

      it 'redirects to groom images with success notice' do
        delete :destroy_image, params: { id: groom.id, image_id: image1.id }
        expect(response).to redirect_to(employee_app_groom_images_path(groom))
        expect(flash[:notice]).to eq('Image deleted')
      end
    end

    context 'when groom has only one image' do
      before do
        # Remove the second image so groom only has one
        image2.destroy if image2.persisted?
      end

      it 'does not destroy the image' do
        expect {
          delete :destroy_image, params: { id: groom.id, image_id: image1.id }
        }.not_to change { groom.reload.images.count }
      end

      it 'redirects with notice about minimum photos' do
        delete :destroy_image, params: { id: groom.id, image_id: image1.id }
        expect(response).to redirect_to(employee_app_groom_images_path(groom))
        expect(flash[:notice]).to eq('Groom needs to always have at least 1 photo')
      end
    end
  end
end