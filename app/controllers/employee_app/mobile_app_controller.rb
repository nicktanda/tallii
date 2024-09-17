module EmployeeApp
  class MobileAppController < ApplicationController
    layout "employee_app"

    skip_before_action :require_pet
    before_action :require_organisation

    def profile
      
    end

    def require_organisation
      unless current_organisation
        redirect_to desktop_organisations_new_path
      end
    end
  end
end