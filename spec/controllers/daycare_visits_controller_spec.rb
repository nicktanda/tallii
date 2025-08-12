require 'rails_helper'

RSpec.describe DaycareVisitsController, type: :controller do
  let(:organisation) { create(:organisation, maximum_daily_daycare_visits: 10, maximum_weekly_daycare_visits: 50, daycare_visit_reward_points: 5) }
  let(:customer) { create(:user, :customer, organisation: organisation, role: 'customer', max_daycare_visits: 10, rewards_points: 0) }
  let(:employee) { create(:user, :employee, organisation: organisation, role: 'employee') }
  let(:pet) { create(:pet, user: customer) }
  let(:daycare_visit) { create(:daycare_visit, pet: pet, organisation: organisation, date: Date.today + 1.day, time: '09:00', status: 'pending') }
  let(:other_organisation) { create(:organisation) }
  let(:other_user) { create(:user, organisation: other_organisation) }
  let(:other_pet) { create(:pet, user: other_user) }
  let(:other_daycare_visit) { create(:daycare_visit, pet: other_pet, organisation: other_organisation) }

  before do
    sign_in_user(customer)
    set_current_pet(pet)
  end

  describe 'GET #index' do
    let!(:daycare_visit1) { create(:daycare_visit, pet: pet, organisation: organisation, date: Date.today + 1.day) }
    let!(:daycare_visit2) { create(:daycare_visit, pet: pet, organisation: organisation, date: Date.today + 2.days) }

    it 'assigns daycare visits for current pet' do
      get :index
      expect(assigns(:daycare_visits)).to match_array([daycare_visit1, daycare_visit2])
    end

    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context 'when user has no current pet' do
      let!(:visit_for_default_pet) { create(:daycare_visit, pet: pet, organisation: organisation, date: Date.today + 3.days) }

      before do
        session.delete(:current_pet)
        visit_for_default_pet
        customer.reload
      end

      it 'uses first pet when no current pet is set' do
        session[:current_pet] = pet.id
        get :index
        expect(assigns(:daycare_visits)).to respond_to(:each)
        expect(assigns(:daycare_visits)).to include(visit_for_default_pet)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the daycare visit' do
      get :show, params: { id: daycare_visit.id }
      expect(assigns(:daycare_visit)).to eq(daycare_visit)
    end

    it 'renders successfully' do
      get :show, params: { id: daycare_visit.id }
      expect(response).to have_http_status(:success)
    end

    it 'raises error when trying to access visit from different organisation' do
      expect {
        get :show, params: { id: other_daycare_visit.id }
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
    let(:valid_params) do
      {
        id: daycare_visit.id,
        daycare_visit: { notes: 'Updated notes', time: '10:00' }
      }
    end
    let(:invalid_params) do
      {
        id: daycare_visit.id,
        daycare_visit: { pet_id: nil }
      }
    end

    context 'with valid parameters' do
      it 'updates the daycare visit' do
        expect(daycare_visit.notes).to eq('Regular daycare visit')
        expect(daycare_visit.time.strftime('%H:%M')).to eq('09:00')

        patch :update, params: valid_params
        daycare_visit.reload
        expect(daycare_visit.notes).to eq('Updated notes')
        expect(daycare_visit.time.strftime('%H:%M')).to eq('10:00')
      end

      it 'redirects to daycare visits path' do
        patch :update, params: valid_params
        expect(response).to redirect_to(daycare_visits_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the daycare visit' do
        allow_any_instance_of(DaycareVisit).to receive(:save).and_return(false)
        original_notes = daycare_visit.notes
        patch :update, params: invalid_params
        daycare_visit.reload
        expect(daycare_visit.notes).to eq(original_notes)
      end

      it 'redirects back with alert' do
        allow_any_instance_of(DaycareVisit).to receive(:save).and_return(false)
        patch :update, params: invalid_params
        expect(response).to redirect_to(daycare_visit_path(daycare_visit))
        expect(flash[:alert]).to eq('Invalid daycare visit information')
      end
    end

    it 'raises error when trying to update visit from different organisation' do
      expect {
        patch :update, params: { id: other_daycare_visit.id, daycare_visit: { notes: 'test' } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        daycare_visit: {
          pet_id: pet.id,
          date: Date.today + 1.day,
          time: '09:00',
          notes: 'Test visit'
        }
      }
    end

    context 'with valid parameters and sufficient visits remaining' do
      it 'creates a new daycare visit' do
        expect {
          post :create, params: valid_params
        }.to change(DaycareVisit, :count).by(1)
      end

      it 'decrements user max_daycare_visits' do
        post :create, params: valid_params
        customer.reload
        expect(customer.max_daycare_visits).to eq(9)
      end

      it 'increments user rewards_points' do
        post :create, params: valid_params
        customer.reload
        expect(customer.rewards_points).to eq(5)
      end

      it 'redirects to daycare visits path with notice' do
        post :create, params: valid_params
        expect(response).to redirect_to(daycare_visits_path)
        expect(flash[:notice]).to eq('Daycare visit created successfully')
      end

      context 'when origin is desktop' do
        let(:valid_params_desktop) do
          valid_params.merge(daycare_visit: valid_params[:daycare_visit].merge(origin: 'desktop'))
        end

        it 'redirects to desktop daycare visits path' do
          post :create, params: valid_params_desktop
          expect(response).to redirect_to(desktop_daycare_visits_path)
        end
      end
    end

    context 'when user has no daycare visits remaining' do
      before { customer.update!(max_daycare_visits: 0) }

      it 'does not create a daycare visit' do
        expect {
          post :create, params: valid_params
        }.not_to change(DaycareVisit, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_daycare_visits_path)
        expect(flash[:alert]).to eq('You have reached your maximum number of daycare visits')
      end

      context 'when origin is desktop' do
        let(:desktop_params) do
          valid_params.merge(daycare_visit: valid_params[:daycare_visit].merge(origin: 'desktop'))
        end

        it 'redirects back with different alert for desktop' do
          post :create, params: desktop_params
          expect(response).to redirect_to(desktop_daycare_visits_new_path)
          expect(flash[:alert]).to eq('User has no more daycare visits in their package. Please confirm the customer would like more daycare visits')
        end
      end
    end

    context 'when daily limit is reached' do
      before do
        organisation.update!(maximum_daily_daycare_visits: 1)
        create(:daycare_visit, organisation: organisation, date: Date.today)
      end

      it 'does not create a daycare visit' do
        expect {
          post :create, params: valid_params
        }.not_to change(DaycareVisit, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_daycare_visits_path)
        expect(flash[:alert]).to eq('We are unable to take any extra daycare visits today, please rebook for another day')
      end

      context 'when origin is desktop' do
        let(:desktop_params) do
          valid_params.merge(daycare_visit: valid_params[:daycare_visit].merge(origin: 'desktop'))
        end

        it 'redirects to desktop path with alert' do
          post :create, params: desktop_params
          expect(response).to redirect_to(desktop_daycare_visits_new_path)
          expect(flash[:alert]).to eq('We are unable to take any extra daycare visits today, please rebook for another day')
        end
      end
    end

    context 'when weekly limit is reached' do
      let(:this_week_params) do
        valid_params.merge(daycare_visit: valid_params[:daycare_visit].merge(date: Date.current + 2.days))
      end
      
      before do
        organisation.update!(maximum_weekly_daycare_visits: 1)
        create(:daycare_visit, organisation: organisation, date: Date.current + 1.day)
      end

      it 'does not create a daycare visit' do
        expect {
          post :create, params: this_week_params
        }.not_to change(DaycareVisit, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: this_week_params
        expect(response).to redirect_to(new_daycare_visits_path)
        expect(flash[:alert]).to eq('We are unable to take any extra daycare visits this week, please rebook for another week')
      end

      context 'when origin is desktop' do
        let(:desktop_this_week_params) do
          this_week_params.merge(daycare_visit: this_week_params[:daycare_visit].merge(origin: 'desktop'))
        end

        it 'redirects to desktop path with alert' do
          post :create, params: desktop_this_week_params
          expect(response).to redirect_to(desktop_daycare_visits_new_path)
          expect(flash[:alert]).to eq('We are unable to take any extra daycare visits this week, please rebook for another week')
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          daycare_visit: {
            pet_id: pet.id,
            date: Date.today - 1.day,
            time: '09:00'
          }
        }
      end

      it 'does not create a daycare visit' do
        expect {
          post :create, params: invalid_params
        }.not_to change(DaycareVisit, :count)
      end

      it 'redirects back with alert for mobile' do
        post :create, params: invalid_params
        expect(response).to redirect_to(desktop_daycare_visits_new_path)
        expect(flash[:alert]).to eq('Invalid daycare visit information')
      end

      context 'when origin is desktop' do
        let(:desktop_invalid_params) do
          invalid_params.merge(daycare_visit: invalid_params[:daycare_visit].merge(origin: 'desktop'))
        end

        it 'redirects to different path with alert for desktop' do
          post :create, params: desktop_invalid_params
          expect(response).to redirect_to(new_daycare_visits_path)
          expect(flash[:alert]).to eq('Invalid daycare visit information')
        end
      end
    end
  end

  describe 'PATCH #confirm' do
    it 'confirms the daycare visit' do
      patch :confirm, params: { id: daycare_visit.id }
      daycare_visit.reload
      expect(daycare_visit.status).to eq('confirmed')
    end

    it 'redirects to daycare visits path' do
      patch :confirm, params: { id: daycare_visit.id }
      expect(response).to redirect_to(daycare_visits_path)
    end

    it 'raises error when trying to confirm visit from different organisation' do
      expect {
        patch :confirm, params: { id: other_daycare_visit.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when update fails' do
      before do
        allow_any_instance_of(DaycareVisit).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'redirects back with alert' do
        expect {
          patch :confirm, params: { id: daycare_visit.id }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'DELETE #delete' do
    it 'destroys the daycare visit' do
      daycare_visit # ensure it exists
      expect {
        delete :delete, params: { id: daycare_visit.id }
      }.to change(DaycareVisit, :count).by(-1)
    end

    it 'redirects to daycare visits path' do
      delete :delete, params: { id: daycare_visit.id }
      expect(response).to redirect_to(daycare_visits_path)
    end

    it 'raises error when trying to delete visit from different organisation' do
      expect {
        delete :delete, params: { id: other_daycare_visit.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when destroy fails' do
      before do
        allow_any_instance_of(DaycareVisit).to receive(:destroy).and_return(false)
      end

      it 'does not delete the daycare visit' do
        daycare_visit # ensure it exists
        expect {
          delete :delete, params: { id: daycare_visit.id }
        }.not_to change(DaycareVisit, :count)
      end

      it 'redirects back with alert' do
        delete :delete, params: { id: daycare_visit.id }
        expect(response).to redirect_to(daycare_visits_path)
        expect(flash[:alert]).to eq('Please try again')
      end
    end
  end
end