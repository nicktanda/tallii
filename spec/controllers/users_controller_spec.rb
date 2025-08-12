require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:organisation) { create(:organisation) }
  let(:customer) { create(:user, :customer, organisation: organisation, password: 'old_password') }
  let(:pet) { create(:pet, user: customer) }

  before do
    # Mock authenticate method
    allow_any_instance_of(User).to receive(:authenticate) do |user, password|
      password == 'old_password' ? user : false
    end
    
    sign_in_user(customer)
    set_current_pet(pet)
  end

  describe 'PATCH #update' do
    let(:valid_params) do
      {
        id: customer.id,
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
        id: customer.id,
        user: {
          first_name: nil
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the user' do
        patch :update, params: valid_params
        customer.reload
        expect(customer.first_name).to eq('Updated')
        expect(customer.last_name).to eq('Name')
        expect(customer.email).to eq('updated@example.com')
        expect(customer.phone).to eq('1234567890')
      end

      it 'redirects to settings path with notice' do
        patch :update, params: valid_params
        expect(response).to redirect_to(settings_path)
        expect(flash[:notice]).to eq('User updated')
      end

      context 'when image is provided' do
        let(:params_with_image) do
          valid_params.merge(user: valid_params[:user].merge(image: 'fake_image'))
        end

        it 'creates an image for the user' do
          expect_any_instance_of(User).to receive_message_chain(:images, :create!).with(name: "Profile Pic", image: 'fake_image')
          patch :update, params: params_with_image
        end
      end

      context 'when no image is provided' do
        it 'does not create an image' do
          expect_any_instance_of(User).not_to receive(:images)
          patch :update, params: valid_params
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        original_email = customer.email
        patch :update, params: invalid_params
        customer.reload
        expect(customer.email).to eq(original_email)
      end

      it 'redirects back with alert' do
        # Mock the save to fail since User model has minimal validations
        allow(controller).to receive(:current_user).and_return(customer)
        allow(customer).to receive(:save).and_return(false)
        patch :update, params: invalid_params
        expect(response).to redirect_to(settings_path)
        expect(flash[:alert]).to eq('Invalid user information')
      end
    end

    context 'when image creation fails' do
      before do
        allow_any_instance_of(User).to receive_message_chain(:images, :create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises the error' do
        params_with_image = valid_params.merge(user: valid_params[:user].merge(image: 'fake_image'))
        expect {
          patch :update, params: params_with_image
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'GET #reset_password' do
    it 'renders successfully' do
      get :reset_password
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update_password' do
    context 'with correct old password and matching new passwords' do
      let(:valid_password_params) do
        {
          old_password: 'old_password',
          new_password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'updates the user password' do
        allow(controller).to receive(:current_user).and_return(customer)
        expect(customer).to receive(:update).with(password: 'new_password').and_return(true)
        patch :update_password, params: valid_password_params
      end

      it 'redirects to user profile with success notice' do
        allow(customer).to receive(:update).and_return(true)
        patch :update_password, params: valid_password_params
        expect(response).to redirect_to(user_profile_path)
        expect(flash[:notice]).to eq('Password updated')
      end

      context 'when password update fails' do
        it 'redirects with error alert' do
          allow(controller).to receive(:current_user).and_return(customer)
          allow(customer).to receive(:update).and_return(false)
          patch :update_password, params: valid_password_params
          expect(response).to redirect_to(user_profile_path)
          expect(flash[:alert]).to eq('Invalid password')
        end
      end
    end

    context 'with incorrect old password' do
      let(:invalid_old_password_params) do
        {
          old_password: 'wrong_password',
          new_password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'does not update password' do
        expect(customer).not_to receive(:update)
        patch :update_password, params: invalid_old_password_params
      end

      it 'redirects to user profile path without flash message' do
        patch :update_password, params: invalid_old_password_params
        expect(response).to redirect_to(user_profile_path)
        expect(flash[:notice]).to be_nil
        expect(flash[:alert]).to be_nil
      end
    end

    context 'when new passwords do not match' do
      let(:mismatched_password_params) do
        {
          old_password: 'old_password',
          new_password: 'new_password',
          password_confirmation: 'different_password'
        }
      end

      it 'does not update password' do
        expect(customer).not_to receive(:update)
        patch :update_password, params: mismatched_password_params
      end

      it 'redirects to user profile path without flash message' do
        patch :update_password, params: mismatched_password_params
        expect(response).to redirect_to(user_profile_path)
        expect(flash[:notice]).to be_nil
        expect(flash[:alert]).to be_nil
      end
    end
  end

  describe 'DELETE #delete' do
    it 'destroys the current user' do
      user_id = customer.id
      delete :delete, params: { id: customer.id }
      expect { User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to destroy session path' do
      delete :delete, params: { id: customer.id }
      expect(response).to redirect_to(destroy_session_path)
    end

    context 'when user destroy fails' do
      before do
        allow(controller).to receive(:current_user).and_return(customer)
        allow(customer).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it 'raises the error' do
        expect {
          delete :delete, params: { id: customer.id }
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end
end