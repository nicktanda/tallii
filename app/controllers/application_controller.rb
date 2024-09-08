class ApplicationController < ActionController::Base
  before_action :require_authenticated_user
  before_action :require_pet

  Stripe.api_key = "sk_test_51PNCaHEu9YTm4fWpeCNiLjQMQfX6jns4gevTWPefyjEr5mf5uhxsH2c8ZO9pK7SRowuVdaJZTCNBxUh9eztuy23t002bhh4UVb"

  def current_user
    return if session["user"].nil?
    @current_user ||= User.find_by(id: session["user"]["id"])
  end

  def current_pet
    return if session["pet"].nil?
    @current_pet ||= current_user.pets.find_by(id: session["pet"])
  end

  def current_organisation
    @current_organisation ||= current_user.organisation
  end

  def require_authenticated_user
    unless current_user
      return redirect_to desktop_new_session if controller_path.include?("desktop")
      redirect_to new_session_path
    end
  end

  def require_pet
    redirect_to new_pet_onboarding_path unless current_pet
  end

  helper_method :current_user
  helper_method :current_pet
  helper_method :current_organisation
end
