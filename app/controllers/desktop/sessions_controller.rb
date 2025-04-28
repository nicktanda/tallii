module Desktop
  class SessionsController < DesktopController
    skip_before_action :require_organisation
    skip_before_action :require_authenticated_desktop_user

    def new
      return redirect_to desktop_dashboard_path if current_user
    end

    def create
      return redirect_to desktop_dashboard_path if current_user

      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        session["user"] ||= {}
        session["user"]["id"] = user.id
        redirect_to desktop_dashboard_path
      else
        redirect_back fallback_location: desktop_new_session_path, alert: 'Invalid email or password'
      end
    end

    def destroy
      session.delete(:user)
      redirect_to desktop_new_session_path
    end

    private

    def require_organisation
      unless current_organisation
        redirect_to desktop_onboarding_organisation_user_details_path
      end
    end
  end
end