class ApplicationController < ActionController::Base
  before_action :require_authenticated_user
  before_action :require_pet
  before_action :set_stripe_api_key
  before_action :prevent_customer_accessing_desktop

  def prevent_customer_accessing_desktop
    if current_user
      if current_user.role == "customer" && controller_path.include?("desktop")
        redirect_to current_pet_profile_path
      end
    end
  end

  def set_stripe_api_key
    return unless current_organisation
    Stripe.api_key = current_organisation.stripe_api_key.presence || ""
  end

  def current_user
    return if session["user"].nil?
    @current_user ||= User.find_by(id: session["user"]["id"])
  end

  def current_pet
    return if session["pet"].nil?
    @current_pet ||= current_user.pets.find_by(id: session["pet"])
  end

  def current_organisation
    @current_organisation ||= current_user&.organisation if current_user
  end

  def require_authenticated_user
    redirect_to new_session_path unless current_user
  end

  def require_pet
    return if params[:groom][:origin] == "desktop"
    return if params[:daycare_visit][:origin] == "desktop"
    redirect_to new_pet_onboarding_path unless current_pet
  end

  helper_method :current_user
  helper_method :current_pet
  helper_method :current_organisation
end
