require 'rails_helper'

RSpec.describe Desktop::DesktopController, type: :controller do
  # Create a test controller to test the Desktop::DesktopController abstract methods
  controller(Desktop::DesktopController) do
    def index
      render plain: 'test'
    end
  end

  let(:organisation) { create(:organisation) }
  let(:employee) { create(:user, :employee, organisation: organisation, role: 'employee') }
  let(:customer) { create(:user, :customer, organisation: organisation, role: 'customer') }

  describe 'layout' do
    it 'declares desktop layout' do
      expect(Desktop::DesktopController.send(:_layout)).to eq('desktop')
    end
  end

  describe 'before_actions' do
    context 'when user is not authenticated' do
      it 'redirects to desktop session path' do
        get :index
        expect(response).to redirect_to('/login')
      end
    end

    context 'when user is authenticated but has no organisation' do
      let(:user_without_org) { create(:user, :employee, organisation: nil) }
      
      before { sign_in_user(user_without_org) }

      it 'redirects to desktop session path' do
        get :index
        expect(response).to redirect_to('/login')
      end
    end

    context 'when user is authenticated and has organisation' do
      before { sign_in_user(employee) }

      it 'allows access to the action' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#require_authenticated_desktop_user' do
    let(:controller_instance) { described_class.new }

    context 'when current_user is nil' do
      before do
        allow(controller_instance).to receive(:current_user).and_return(nil)
      end

      it 'tries to redirect to desktop_new_session_path but fails when path is nil' do
        # Mock desktop_new_session_path to return nil to simulate the bug
        allow(controller_instance).to receive(:desktop_new_session_path).and_return(nil)
        expect {
          controller_instance.send(:require_authenticated_desktop_user)
        }.to raise_error(ActionController::ActionControllerError, 'Cannot redirect to nil!')
      end
    end

    context 'when current_user exists' do
      before do
        allow(controller_instance).to receive(:current_user).and_return(employee)
      end

      it 'does not redirect' do
        expect(controller_instance).not_to receive(:redirect_to)
        controller_instance.send(:require_authenticated_desktop_user)
      end
    end
  end

  describe '#require_organisation' do
    let(:controller_instance) { described_class.new }

    context 'when current_organisation is nil' do
      before do
        allow(controller_instance).to receive(:current_organisation).and_return(nil)
        allow(controller_instance).to receive(:redirect_to)
      end

      it 'redirects to desktop new session path' do
        # This method actually does redirect unlike require_authenticated_desktop_user
        allow(controller_instance).to receive(:desktop_new_session_path).and_return('/login')
        expect(controller_instance).to receive(:redirect_to).with('/login')
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