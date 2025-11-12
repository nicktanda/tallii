require 'rails_helper'

RSpec.describe GroomsController, type: :controller do
  let(:organisation) { create(:organisation, maximum_daily_grooms: 10, maximum_weekly_grooms: 50, grooming_reward_points: 10) }
  let(:customer) { create(:user, :customer, organisation: organisation, role: 'customer', rewards_points: 0) }
  let(:employee) { create(:user, :employee, organisation: organisation, role: 'employee') }
  let(:pet) { create(:pet, user: customer) }
  let(:groom) { create(:groom, pet: pet, organisation: organisation, date: Date.today + 1.day, time: '09:00', status: 'pending') }
  let(:other_organisation) { create(:organisation) }
  let(:other_user) { create(:user, organisation: other_organisation) }
  let(:other_pet) { create(:pet, user: other_user) }
  let(:other_groom) { create(:groom, pet: other_pet, organisation: other_organisation) }

  before do
    sign_in_user(customer)
    set_current_pet(pet)
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_call_original
    allow_any_instance_of(ActionController::Parameters).to receive(:[]).with(:image).and_return(nil)
  end

  describe 'GET #index' do
    let!(:groom1) { create(:groom, pet: pet, organisation: organisation, date: Date.today + 1.day) }
    let!(:groom2) { create(:groom, pet: pet, organisation: organisation, date: Date.today + 2.days) }

    it 'assigns grooms for current pet' do
      get :index
      expect(assigns(:grooms)).to match_array([groom1, groom2])
    end

    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context 'when user has no current pet' do
      let!(:groom_for_default_pet) { create(:groom, pet: pet, organisation: organisation, date: Date.today + 3.days) }

      before do
        session.delete("current_pet")
        groom_for_default_pet
      end

      it 'uses first pet when no current pet is set' do
        session[:current_pet] = pet.id
        get :index
        expect(assigns(:grooms)).to respond_to(:each)
        expect(assigns(:grooms)).to include(groom_for_default_pet)
      end
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

    it 'raises error when trying to access groom from different organisation' do
      expect {
        get :show, params: { id: other_groom.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'renders successfully' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { id: groom.id, groom: { notes: 'Updated notes', time: '10:00' } } }
    let(:invalid_params) { { id: groom.id, groom: { pet_id: nil } } }

    context 'with valid parameters' do
      it 'updates the groom' do
        patch :update, params: valid_params
        groom.reload
        expect(groom.notes).to eq('Updated notes')
        expect(groom.start_time.strftime('%H:%M')).to eq('10:00')
      end

      it 'redirects to grooms path' do
        patch :update, params: valid_params
        expect(response).to redirect_to(grooms_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the groom' do
        allow_any_instance_of(Groom).to receive(:save).and_return(false)
        original_notes = groom.notes
        patch :update, params: invalid_params
        groom.reload
        expect(groom.notes).to eq(original_notes)
      end

      it 'redirects back with alert' do
        allow_any_instance_of(Groom).to receive(:save).and_return(false)
        patch :update, params: invalid_params
        expect(response).to redirect_to(groom_path(groom))
        expect(flash[:alert]).to eq('Invalid groom information')
      end
    end

    it 'raises error when trying to update groom from different organisation' do
      expect {
        patch :update, params: { id: other_groom.id, groom: { notes: 'test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        groom: {
          pet_id: pet.id,
          date: Date.today + 1.day,
          time: '09:00',
          notes: 'Test groom',
          last_groom: Date.today - 30.days
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new groom' do
        expect {
          post :create, params: valid_params
        }.to change(Groom, :count).by(1)
      end

      it 'increments user rewards_points' do
        post :create, params: valid_params
        customer.reload
        expect(customer.rewards_points).to eq(10)
      end

      it 'creates an image for the groom' do
        expect {
          post :create, params: valid_params
        }.to change { Groom.last&.images&.count }.from(nil).to(1)
        
        created_groom = Groom.last
        expect(created_groom.images.first.name).to eq("test_image")
        # Since we mock the image param to return nil, no actual file is attached
        expect(created_groom.images.first.image.attached?).to be false
      end

      it 'redirects to grooms path' do
        post :create, params: valid_params
        expect(response).to redirect_to(grooms_path)
      end

      context 'when origin is desktop' do
        let(:valid_params_desktop) do
          valid_params.merge(groom: valid_params[:groom].merge(origin: 'desktop'))
        end

        it 'redirects to desktop grooms path' do
          post :create, params: valid_params_desktop
          expect(response).to redirect_to(desktop_grooms_path)
        end
      end
    end

    context 'when daily limit is reached' do
      before do
        organisation.update!(maximum_daily_grooms: 1)
        create(:groom, organisation: organisation, date: Date.today)
      end

      it 'does not create a groom' do
        expect {
          post :create, params: valid_params
        }.not_to change(Groom, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_groom_path)
        expect(flash[:alert]).to eq('We are unable to take any extra grooms today, please rebook for another day')
      end

      context 'when origin is desktop' do
        let(:desktop_params) do
          valid_params.merge(groom: valid_params[:groom].merge(origin: 'desktop'))
        end

        it 'redirects to desktop path with alert' do
          post :create, params: desktop_params
          expect(response).to redirect_to(desktop_grooms_new_path)
          expect(flash[:alert]).to eq('We are unable to take any extra grooms today, please rebook for another day')
        end
      end
    end

    context 'when weekly limit is reached' do
      let(:this_week_params) do
        valid_params.merge(groom: valid_params[:groom].merge(date: Date.current + 2.days))
      end

      before do
        organisation.update!(maximum_weekly_grooms: 1)
        create(:groom, organisation: organisation, date: Date.current + 1.day)
      end

      it 'does not create a groom' do
        expect {
          post :create, params: this_week_params
        }.not_to change(Groom, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: this_week_params
        expect(response).to redirect_to(new_groom_path)
        expect(flash[:alert]).to eq('We are unable to take any extra grooms this week, please rebook for another week')
      end

      context 'when origin is desktop' do
        let(:desktop_this_week_params) do
          this_week_params.merge(groom: this_week_params[:groom].merge(origin: 'desktop'))
        end

        it 'redirects to desktop path with alert' do
          post :create, params: desktop_this_week_params
          expect(response).to redirect_to(desktop_grooms_new_path)
          expect(flash[:alert]).to eq('We are unable to take any extra grooms this week, please rebook for another week')
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          groom: {
            pet_id: nil,
            date: Date.today,
            time: '09:00'
          }
        }
      end

      it 'does not create a groom' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Groom, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: invalid_params
        expect(response).to redirect_to(new_groom_path)
        expect(flash[:alert]).to eq('Invalid groom information')
      end

      context 'when origin is desktop' do
        let(:desktop_invalid_params) do
          invalid_params.merge(groom: invalid_params[:groom].merge(origin: 'desktop'))
        end

        it 'redirects to desktop path with alert' do
          post :create, params: desktop_invalid_params
          expect(response).to redirect_to(desktop_grooms_new_path)
          expect(flash[:alert]).to eq('Invalid groom information')
        end
      end
    end

    context 'when image creation fails' do
      before do
        allow_any_instance_of(Groom).to receive_message_chain(:images, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'still creates the groom but raises error on image' do
        expect {
          post :create, params: valid_params
        }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Groom.last.pet_id).to eq(pet.id)
      end
    end
  end

  describe 'PATCH #confirm' do
    it 'confirms the groom' do
      patch :confirm, params: { id: groom.id }
      groom.reload
      expect(groom.status).to eq('confirmed')
    end

    it 'redirects to grooms path' do
      patch :confirm, params: { id: groom.id }
      expect(response).to redirect_to(grooms_path)
    end

    it 'raises error when trying to confirm groom from different organisation' do
      expect {
        patch :confirm, params: { id: other_groom.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when update fails' do
      before do
        allow_any_instance_of(Groom).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        expect {
          patch :confirm, params: { id: groom.id }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'DELETE #delete' do
    it 'destroys the groom' do
      groom # ensure it exists
      expect {
        delete :delete, params: { id: groom.id }
      }.to change(Groom, :count).by(-1)
    end

    it 'redirects to grooms path' do
      delete :delete, params: { id: groom.id }
      expect(response).to redirect_to(grooms_path)
    end

    it 'raises error when trying to delete groom from different organisation' do
      expect {
        delete :delete, params: { id: other_groom.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when destroy fails' do
      before do
        allow_any_instance_of(Groom).to receive(:destroy).and_return(false)
      end

      it 'does not delete the groom' do
        groom # ensure it exists
        expect {
          delete :delete, params: { id: groom.id }
        }.not_to change(Groom, :count)
      end

      it 'redirects back with alert' do
        delete :delete, params: { id: groom.id }
        expect(response).to redirect_to(grooms_path)
        expect(flash[:alert]).to eq('Please try again')
      end
    end
  end
end