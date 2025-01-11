class OnboardingUsersController < ApplicationController
  before_action :user, except: [:new]
  before_action :prevent_access_if_user_exists

  skip_before_action :require_authenticated_user
  skip_before_action :prevent_customer_accessing_desktop
  skip_before_action :require_pet

  def new
    @user = OnboardingUser.create!
  end

  def email; end
  def update_email
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
    @user.update!(phone: params[:phone])
    redirect_to update_user_organisation_onboarding_path(@user)
  end

  def organisation
    @organisations = Organisation.all.map { |o| { name: o.name, id: o.id } }
  end
  def update_organisation
    @user.update!(organisation_id: params[:organisation_id])
    redirect_to complete_user_onboarding_path(@user)
  end

  def complete; end
  def create_user
    user_attributes = @user.attributes.except("id", "created_at", "updated_at")

    user = User.create!(user_attributes)
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
end
