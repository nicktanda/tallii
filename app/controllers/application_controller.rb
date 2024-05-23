class ApplicationController < ActionController::Base
  before_action :require_authenticated_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_organisation
    @current_organisation ||= current_user.organisation
  end

  def require_authenticated_user
    redirect_to new_session_path unless current_user
  end

  helper_method :current_user
  helper_method :current_organisation
end
