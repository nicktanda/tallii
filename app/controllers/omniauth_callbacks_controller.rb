class OmniauthCallbacksController < ApplicationController
  skip_before_action :require_authenticated_user
  skip_before_action :require_pet
  skip_before_action :prevent_customer_accessing_desktop

  def create
    auth = request.env['omniauth.auth']
    origin = request.env['omniauth.origin']

    # Determine if this is a desktop or mobile login based on origin
    is_desktop = origin&.include?('/login') || origin&.include?('/sign_up')

    # Try to find existing user by provider/uid or by email
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email)

    if user
      # Update OAuth credentials if linking existing account
      if user.provider.nil?
        user.update!(
          provider: auth.provider,
          uid: auth.uid,
          avatar_url: auth.info.image
        )
      end
    else
      # Create new user
      user = User.create!(
        email: auth.info.email,
        first_name: auth.info.first_name || auth.info.name&.split&.first,
        last_name: auth.info.last_name || auth.info.name&.split&.last,
        provider: auth.provider,
        uid: auth.uid,
        avatar_url: auth.info.image,
        role: is_desktop ? :admin : :customer
      )
    end

    # Set session
    session["user"] ||= {}
    session["user"]["id"] = user.id

    # Redirect based on context
    if is_desktop
      if user.organisation.present?
        redirect_to desktop_dashboard_path, notice: 'Signed in with Google successfully.'
      else
        redirect_to desktop_onboarding_organisation_organisation_details_path(user), notice: 'Please complete your organisation setup.'
      end
    else
      session["current_pet"] = user.pets.first.id if user.pets.any?
      if user.role == "customer"
        if user.pets.any?
          redirect_to current_pet_profile_path, notice: 'Signed in with Google successfully.'
        else
          redirect_to new_pet_onboarding_path, notice: 'Please add your first pet.'
        end
      else
        redirect_to mobile_app_profile_path, notice: 'Signed in with Google successfully.'
      end
    end
  end

  def failure
    redirect_to desktop_new_session_path, alert: "Authentication failed: #{params[:message]}"
  end
end
