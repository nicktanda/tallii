class SessionsController < ApplicationController
  skip_before_action :require_authenticated_user
  skip_before_action :require_pet
  skip_before_action :prevent_customer_accessing_desktop

  def new
    return redirect_to current_pet_profile_path if current_user
  end

  def create
    return redirect_to current_pet_profile_path if current_user

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session["user"] ||= {}
      session["user"]["id"] = user.id
      session["current_pet"] = user.pets.first.id if user.pets.any?
      if current_user.role == "customer"
        redirect_to current_pet_profile_path
      else
        redirect_to mobile_app_profile_path
      end
    else
      redirect_back fallback_location: new_session_path, alert: 'Invalid email or password'
    end
  end

  def destroy
    session.delete(:user)
    redirect_to new_session_path
  end

  def set_current_pet
    session["current_pet"] = params[:id]
    redirect_to current_pet_profile_path
  end

  private

  def prevent_users_reaching_platform_switch
    return if current_user.nil?
    redirect_to current_pet_profile_path if current_user.role == "customer"
  end

  def require_organisation
    unless current_organisation
      redirect_to desktop_onboarding_organisation_user_details_path
    end
  end
end