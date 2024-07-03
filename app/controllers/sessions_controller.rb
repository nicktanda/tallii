class SessionsController < ApplicationController
  skip_before_action :require_authenticated_user

  def new
    return redirect_to root_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session["user"] ||= {}
      session["user"]["id"] = user.id
      redirect_to root_path
    else
      redirect_back fallback_location: new_session_path, alert: 'Invalid email or password'
    end
  end

  def destroy
    session.delete(:user)
    redirect_to new_session_path
  end
end