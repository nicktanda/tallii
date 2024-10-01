module Desktop
  module Users
    class UsersController < DesktopController
      skip_before_action :require_authenticated_user, only: [:new, :create]
      skip_before_action :prevent_customer_accessing_desktop, only: [:new, :create]
      skip_before_action :require_organisation

      def new
        @organisations = [{ name: "New Location", id: nil }] + Organisation.all.map { |o| { name: o.name, id: o.id } }
      end

      def create
        user = if user_params[:organisation_id].empty?
          User.new(user_params)
        else
          Organisation.find(user_params[:organisation_id]).users.new(user_params)
        end

        if user.save
          session["user"] ||= {}
          session[:user][:id] = user.id
          return redirect_to desktop_organisations_new_path if user_params[:organisation_id].empty?
          redirect_to desktop_user_path(user)
        else
          redirect_back fallback_location: desktop_users_new_path, alert: 'Invalid email'
        end
      end

      def update
        user = current_organisation.users.find(user_params[:id])

        user.assign_attributes(user_params)
        user.images.create!(name: "Profile Pic", image: params[:user][:image]) if params[:user][:image]

        if user.save
          redirect_to desktop_user_path(user), notice: 'User updated'
        else
          redirect_back fallback_location: desktop_user_path(user), alert: 'Invalid user information'
        end
      end

      def delete
        user = current_organisation.users.find(params[:id])
        redirect_to desktop_users_path if user == current_user

        user.archive
        redirect_to desktop_users_path
      end

      private

      def user_params
        params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :phone, :weight, :notes, :address, :city, :postcode, :max_daycare_visits, :organisation_id, :colour, :rewards_points)
      end
    end
  end
end