module Desktop
  class SessionsController < DesktopController
    skip_before_action :require_authenticated_user
    skip_before_action :require_organisation

    def new
      return redirect_to desktop_dashboard_path if current_user
    end

    def create
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        session["user"] ||= {}
        session["user"]["id"] = user.id
        session["pet"] = user.pets.first.id if user.pets.any?
        redirect_to desktop_dashboard_path
      else
        redirect_back fallback_location: desktop_new_session_path, alert: 'Invalid email or password'
      end
    end

    def destroy
      session.delete(:user)
      redirect_to desktop_new_session_path
    end
  end
end