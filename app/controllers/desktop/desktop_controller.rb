module Desktop
  class DesktopController < ApplicationController
    layout "desktop"

    skip_before_action :require_authenticated_user
    skip_before_action :require_pet
    before_action :require_organisation

    def require_organisation
      unless current_organisation
        redirect_to desktop_onboarding_organisation_user_details_path
      end
    end
  end
end