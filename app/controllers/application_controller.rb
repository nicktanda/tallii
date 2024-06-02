class ApplicationController < ActionController::Base
  before_action :require_authenticated_user

  Stripe.api_key = "sk_test_51PNCaHEu9YTm4fWpeCNiLjQMQfX6jns4gevTWPefyjEr5mf5uhxsH2c8ZO9pK7SRowuVdaJZTCNBxUh9eztuy23t002bhh4UVb"

  def current_user
    return if session["user"].nil?
    @current_user ||= User.find_by(id: session["user"]["id"])
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
