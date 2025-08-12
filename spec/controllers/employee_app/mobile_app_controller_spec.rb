require 'rails_helper'

RSpec.describe EmployeeApp::MobileAppController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation) }

  before do
    sign_in_user(employee)
  end

  describe 'GET #profile' do
    it 'renders successfully' do
      get :profile
      expect(response).to have_http_status(:success)
    end

    it 'renders the profile template' do
      get :profile
      expect(response).to render_template(:profile)
    end
  end

  describe 'GET #user_settings' do
    it 'renders successfully' do
      get :user_settings
      expect(response).to have_http_status(:success)
    end

    it 'renders the user_settings template' do
      get :user_settings
      expect(response).to render_template(:user_settings)
    end
  end

  describe 'PATCH #update_user_settings' do
    let(:valid_params) do
      {
        user: {
          first_name: 'Updated',
          last_name: 'Name',
          email: 'updated@example.com',
          phone: '1234567890'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          password: ''
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the user' do
        patch :update_user_settings, params: valid_params
        employee.reload
        expect(employee.first_name).to eq('Updated')
        expect(employee.last_name).to eq('Name')
        expect(employee.email).to eq('updated@example.com')
        expect(employee.phone).to eq('1234567890')
      end

      it 'redirects to mobile app profile with success notice' do
        patch :update_user_settings, params: valid_params
        expect(response).to redirect_to(mobile_app_profile_path)
        expect(flash[:notice]).to eq('User settings updated successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        original_email = employee.email
        patch :update_user_settings, params: invalid_params
        employee.reload
        expect(employee.email).to eq(original_email)
      end

      it 'redirects to profile with success notice' do
        patch :update_user_settings, params: invalid_params
        expect(response).to redirect_to(mobile_app_profile_path)
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe '#require_organisation' do
    let(:controller_instance) { described_class.new }

    context 'when current_organisation is nil' do
      before do
        allow(controller_instance).to receive(:current_organisation).and_return(nil)
        allow(controller_instance).to receive(:redirect_to)
        allow(controller_instance).to receive(:desktop_onboarding_organisation_user_details_path).and_return('/sign_up')
      end

      it 'redirects to desktop onboarding organisation user details path' do
        expect(controller_instance).to receive(:redirect_to).with('/sign_up')
        controller_instance.send(:require_organisation)
      end
    end

    context 'when current_organisation exists' do
      before do
        allow(controller_instance).to receive(:current_organisation).and_return(organisation)
      end

      it 'does not redirect' do
        expect(controller_instance).not_to receive(:redirect_to)
        controller_instance.send(:require_organisation)
      end
    end
  end
end