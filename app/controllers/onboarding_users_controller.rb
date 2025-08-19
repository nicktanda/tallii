class OnboardingUsersController < ApplicationController
  before_action :user, except: [:new]
  before_action :prevent_access_if_user_exists
  before_action :prevent_onboarding_without_access_code, except: [:new, :access_code, :update_access_code]

  skip_before_action :require_authenticated_user
  skip_before_action :prevent_customer_accessing_desktop
  skip_before_action :require_pet

  def new
    @user = OnboardingUser.create!
  end

  def access_code; end
  def update_access_code
    organisation = Organisation.find_by(access_code: params[:access_code])

    unless organisation
      return redirect_to user_access_code_onboarding_path(@user), alert: "Invalid access code!"
    end

    @user.update!(access_code: params[:access_code])
    redirect_to user_email_onboarding_path(@user)
  end

  def email; end
  def update_email
    user = User.find_by(email: params[:email])

    return redirect_to user_email_onboarding_path(@user), alert: "Email already exists!" if user

    @user.update!(email: params[:email])
    redirect_to user_password_onboarding_path(@user)
  end

  def password; end
  def update_password
    @user.update!(password: params[:password])
    redirect_to user_name_onboarding_path(@user)
  end

  def name; end
  def update_name
    @user.update!(first_name: params[:first_name], last_name: params[:last_name])
    # redirect_to user_address_onboarding_path(@user)
    redirect_to user_phone_onboarding_path(@user)
  end

  def address; end
  def update_address
    @user.update!(address: params[:address], city: params[:city], postcode: params[:postcode])
    redirect_to user_phone_onboarding_path(@user)
  end

  def phone; end
  def update_phone
    @user.update!(phone: params["[country_code]"] + params["phone"])
    redirect_to complete_user_onboarding_path(@user)
  end

  def complete; end
  def create_user
    organisation = Organisation.find_by(access_code: @user.access_code)
    user_attributes = @user.attributes.except("id", "created_at", "updated_at", "access_code")

    user = organisation.users.create!(user_attributes)
    session["user"] ||= {}
    session["user"]["id"] = user.id

    @user.destroy!
    redirect_to new_pet_onboarding_path(user)
  end

  private

  def user
    @user ||= OnboardingUser.find(params[:id])
  end

  def prevent_access_if_user_exists
    redirect_to new_pet_onboarding_path(User.find(session["user"]["id"])) if session["user"]
  end

  def prevent_onboarding_without_access_code
    redirect_to user_access_code_onboarding_path(@user), alert: "Invalid access code!" if @user.access_code.nil?
  end
end
