module Desktop
  class DesktopController < ApplicationController
    layout "desktop"

    skip_before_action :require_authenticated_user
    skip_before_action :require_pet
    before_action :require_organisation
    before_action :require_authenticated_desktop_user

    def require_authenticated_desktop_user
      unless current_user
        desktop_new_session_path
      end
    end

    def require_organisation
      unless current_organisation
        redirect_to desktop_new_session_path
      end
    end
  end
end