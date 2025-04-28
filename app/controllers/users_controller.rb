class UsersController < ApplicationController
  skip_before_action :require_authenticated_user, only: [:new, :create]
  skip_before_action :prevent_customer_accessing_desktop, only: [:new, :create]
  skip_before_action :require_pet, only: [:new, :create]

  def update
    current_user.assign_attributes(user_params)
    current_user.images.create!(name: "Profile Pic", image: params[:user][:image]) if params[:user][:image]

    if current_user.save
      redirect_to settings_path, notice: 'User updated'
    else
      redirect_back fallback_location: settings_path, alert: 'Invalid user information'
    end
  end

  def reset_password; end

  def update_password
    return redirect_to user_profile_path unless current_user.authenticate(params[:old_password])
    return redirect_to user_profile_path unless params[:new_password] == params[:password_confirmation]

    if current_user.update(password: params[:new_password])
      redirect_to user_profile_path, notice: 'Password updated'
    else
      redirect_to user_profile_path, alert: 'Invalid password'
    end
  end

  def delete
    current_user.destroy!
    redirect_to destroy_session_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :weight, :address, :city, :postcode, :organisation_id, :role)
  end
end