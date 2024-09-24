module EmployeeApp
  class MobileAppController < ApplicationController
    layout "employee_app"

    skip_before_action :require_pet
    before_action :require_organisation

    def profile; end

    def user_settings; end

    def update_user_settings
      current_user.assign_attributes(user_params)

      if current_user.save
        flash[:notice] = "User settings updated successfully"
        redirect_to mobile_app_profile_path
      else
        flash[:alert] = current_user.errors.full_messages.join(", ")
        redirect_to mobile_app_user_settings_path
      end
    end

    def require_organisation
      unless current_organisation
        redirect_to desktop_organisations_new_path
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone)
    end
  end
end