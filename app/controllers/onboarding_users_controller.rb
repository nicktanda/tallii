class OnboardingUsersController < ApplicationController
  before_action :user, except: [:new]
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
    @user.update!(password: params[:password])
    redirect_to user_name_onboarding_path(@user)
  end

  def name; end
  def update_name
    @user.update!(first_name: params[:first_name], last_name: params[:last_name])
    redirect_to user_phone_onboarding_path(@user)
  end

  def phone; end
  def update_phone
    @user.update!(phone: params[:phone])
    redirect_to user_address_onboarding_path(@user)
  end

  def address; end
  def update_address
    @user.update!(address: params[:address], city: params[:city], postcode: params[:postcode])
    redirect_to user_city_onboarding_path(@user)
  end

  def organisation; end
  def update_organisation
    @user.update!(organisation_id: params[:organisation_id])
    redirect_to complete_onboarding_path(@user)
  end

  def complete; end
  def create_user
    user_attributes = @user.attributes.except("id", "created_at", "updated_at")
    user = OnboardingUser.create!(user_attributes)
    @user.destroy!
    redirect_to user_path(user), notice: 'User created successfully'
  end

  private

  def user
    @user ||= OnboardingUser.find(params[:id])
  end
end
