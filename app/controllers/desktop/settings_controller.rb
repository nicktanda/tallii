module Desktop
  class SettingsController < DesktopController
    def index; end

    def user; end
    def update_user
      current_user.assign_attributes(user_params)
      current_user.images.create!(name: "Profile Pic", image: params[:user][:image]) if params[:user][:image]

      if current_user.save
        redirect_to desktop_settings_path, notice: 'User updated'
      else
        redirect_back fallback_location: desktop_user_settings_path, alert: 'Invalid user information'
      end
    end

    def organisation; end
    def update_organisation

    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :phone, :weight, :address, :city, :postcode)
    end
  end
end