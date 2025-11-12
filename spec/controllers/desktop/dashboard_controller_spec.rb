require 'rails_helper'

RSpec.describe Desktop::DashboardController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }
  let(:pet) { create(:pet, user: customer) }

  before do
    sign_in_user(employee)
  end

  describe 'GET #index' do
    let(:today) { Date.today }
    let(:tomorrow) { Date.today + 1.day }

    let!(:groom_today) { create(:groom, organisation: organisation, date: today, start_time: '09:00', pet: pet) }
    let!(:groom_tomorrow) { create(:groom, organisation: organisation, date: tomorrow, start_time: '10:00', pet: pet) }
    let!(:temp_groom_today) { create(:temporary_groom, organisation: organisation, date: today, start_time: '11:00') }

    let!(:daycare_visit_today) { create(:daycare_visit, organisation: organisation, date: today, start_time: '12:00', pet: pet) }
    let!(:daycare_visit_tomorrow) { create(:daycare_visit, organisation: organisation, date: tomorrow, start_time: '13:00', pet: pet) }
    let!(:temp_daycare_visit_today) { create(:temporary_daycare_visit, organisation: organisation, date: today, start_time: '14:00') }

    context 'when no date parameter is provided' do
      it 'uses today as the default date' do
        get :index
        expect(assigns(:date)).to eq(Date.today)
      end

      it 'assigns grooms for today including temporary grooms' do
        get :index
        expect(assigns(:grooms)).to match_array([groom_today, temp_groom_today])
      end

      it 'assigns daycare visits for today including temporary visits' do
        get :index
        expect(assigns(:daycare_visits)).to match_array([daycare_visit_today, temp_daycare_visit_today])
      end

      it 'assigns bookings sorted by time' do
        get :index
        expected_bookings = [groom_today, temp_groom_today, daycare_visit_today, temp_daycare_visit_today]
        expect(assigns(:bookings)).to eq(expected_bookings.sort_by(&:time))
      end

      it 'renders successfully' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when date parameter is provided' do
      let(:specific_date) { Date.current + 30.days }
      let(:date_param) { "#{specific_date.year}-#{specific_date.month}-#{specific_date.day}" }
      let!(:groom_specific_date) { create(:groom, organisation: organisation, date: specific_date, start_time: '15:00', pet: pet) }
      let!(:daycare_visit_specific_date) { create(:daycare_visit, organisation: organisation, date: specific_date, start_time: '16:00', pet: pet) }

      it 'parses the date parameter correctly' do
        get :index, params: { date: date_param }
        expect(assigns(:date)).to eq(specific_date)
      end

      it 'assigns grooms for the specified date' do
        get :index, params: { date: date_param }
        expect(assigns(:grooms)).to include(groom_specific_date)
        expect(assigns(:grooms)).not_to include(groom_today)
      end

      it 'assigns daycare visits for the specified date' do
        get :index, params: { date: date_param }
        expect(assigns(:daycare_visits)).to include(daycare_visit_specific_date)
        expect(assigns(:daycare_visits)).not_to include(daycare_visit_today)
      end

      context 'with different date format variations' do
        it 'handles single digit month and day' do
          future_date = Date.current + 60.days
          date_str = "#{future_date.year}-#{future_date.month}-#{future_date.day}"
          get :index, params: { date: date_str }
          expect(assigns(:date)).to eq(future_date)
        end

        it 'handles double digit month and day' do
          future_date = Date.current + 90.days  
          date_str = "#{future_date.year}-#{future_date.month.to_s.rjust(2, '0')}-#{future_date.day.to_s.rjust(2, '0')}"
          get :index, params: { date: date_str }
          expect(assigns(:date)).to eq(future_date)
        end
      end
    end

    context 'when both regular and temporary bookings exist' do
      it 'combines regular and temporary grooms' do
        get :index
        expect(assigns(:grooms)).to include(groom_today)
        expect(assigns(:grooms)).to include(temp_groom_today)
        expect(assigns(:grooms)).not_to include(groom_tomorrow)
      end

      it 'combines regular and temporary daycare visits' do
        get :index
        expect(assigns(:daycare_visits)).to include(daycare_visit_today)
        expect(assigns(:daycare_visits)).to include(temp_daycare_visit_today)
        expect(assigns(:daycare_visits)).not_to include(daycare_visit_tomorrow)
      end

      it 'sorts all bookings by time regardless of type' do
        get :index
        bookings = assigns(:bookings)
        times = bookings.map(&:time)
        expect(times).to eq(times.sort)
      end
    end

    context 'when no bookings exist for the date' do
      let(:future_date) { Date.today + 30.days }

      it 'assigns empty arrays' do
        get :index, params: { date: future_date.strftime("%Y-%-m-%-d") }
        expect(assigns(:grooms)).to be_empty
        expect(assigns(:daycare_visits)).to be_empty
        expect(assigns(:bookings)).to be_empty
      end
    end

    context 'when bookings exist for other organisations' do
      let(:other_organisation) { create(:organisation) }
      let(:other_user) { create(:user, organisation: other_organisation) }
      let(:other_pet) { create(:pet, user: other_user) }
      let!(:other_groom) { create(:groom, organisation: other_organisation, date: today, pet: other_pet) }

      it 'only shows bookings for the current organisation' do
        get :index
        expect(assigns(:grooms)).not_to include(other_groom)
      end
    end
  end
end