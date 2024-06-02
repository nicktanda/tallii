class UsersController < ApplicationController
  skip_before_action :require_authenticated_user, only: [:new, :create]

  def new; end

  def create
    user = User.new(user_params)

    if user.save
      session[:user][:id] = user.id
      redirect_to root_path
    else
      redirect_back fallback_location: new_user_path, alert: 'Invalid email or password'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end