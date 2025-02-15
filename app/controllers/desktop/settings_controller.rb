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
      current_organisation.assign_attributes(organisation_params)

      if current_organisation.save
        redirect_to desktop_settings_path, notice: 'Organisation updated'
      else
        redirect_back fallback_location: desktop_organisation_settings_path, alert: 'Invalid organisation information'
      end
    end

    def staff; end

    def retail; end
    def update_retail
      current_organisation.assign_attributes(organisation_params)

      if current_organisation.save
        redirect_to desktop_settings_path, notice: 'Organisation updated'
      else
        redirect_back fallback_location: desktop_retail_settings_path, alert: 'Invalid retail information'
      end
    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :phone, :weight, :address, :city, :postcode)
    end

    def organisation_params
      params.require(:organisation).permit(:id, :name, :email, :phone, :address, :city, :postcode, :maximum_weekly_daycare_visits, :maximum_daily_daycare_visits, :maximum_weekly_grooms, :maximum_daily_grooms, :stripe_api_key, :grooming_reward_points, :daycare_visit_reward_points)
    end
  end
end