class SessionsController < ApplicationController
  skip_before_action :require_authenticated_user
  skip_before_action :require_pet
  skip_before_action :prevent_customer_accessing_desktop
  before_action :prevent_users_reaching_platform_switch, only: :choose_platform
  before_action :require_organisation, only: :choose_platform

  def choose_platform; end

  def new
    return redirect_to current_pet_profile_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session["user"] ||= {}
      session["user"]["id"] = user.id
      session["pet"] = user.pets.first.id if user.pets.any?
      if current_user.role == "customer"
        redirect_to current_pet_profile_path
      else
        redirect_to root_path
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
    session["pet"] = params[:id]
    redirect_to current_pet_profile_path
  end

  private

  def prevent_users_reaching_platform_switch
    redirect_to current_pet_profile_path if current_user.role == "customer"
  end

  def require_organisation
    unless current_organisation
      redirect_to desktop_organisations_new_path
    end
  end
end