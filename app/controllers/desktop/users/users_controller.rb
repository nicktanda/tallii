module Desktop
  module Users
    class UsersController < DesktopController
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
          return redirect_to desktop_onboarding_organisation_user_details_path if user_params[:organisation_id].empty?
          redirect_to desktop_user_path(user)
        else
          redirect_back fallback_location: desktop_users_new_path, alert: 'Invalid email'
        end
      end

      def create_staff
        user = current_organisation.users.new(user_params)

        if user.save
          redirect_to desktop_staff_settings_path, alert: "Staff member created"
        else
          redirect_to desktop_staff_settings_path, alert: "Staff member not created"
        end
      end

      def create_customer
        user = current_organisation.users.new
        user.first_name = params[:first_name]
        user.last_name = params[:last_name]
        user.email = params[:email]
        user.phone = params[:phone]
        user.address = params[:address]
        user.city = params[:city]
        user.postcode = params[:postcode]
        user.password = "password"
        user.role = "customer"
        
        pet = current_organisation.pets.new
        pet.name = params[:name]
        pet.species = params[:species]
        pet.gender = params[:gender]
        pet.breed = params[:breed]
        pet.weight = params[:weight]
        pet.dob = params[:dob]
        pet.status = params[:status]
        pet.allergies = params[:allergies]
        pet.medication = params[:medication]
        pet.health_conditions = ""

        if user.save
          pet.user = user
          pet.save

          flash.now[:alert] = "Successfully created customer!"
          render js: "window.location.reload(true);"
        else
          flash.now[:alert] = "Something went wrong!"
          render js: "window.location.reload(true);"
        end
      end

      def update
        user = current_organisation.users.find(user_params[:id])

        user.assign_attributes(user_params)
        user.images.create!(name: "Profile Pic", image: params[:user][:image]) if params[:user][:image]

        if user.save
          user.update!(colour_codes: params[:user][:colour_codes] || [])

          redirect_to desktop_user_edit_path(user), notice: 'User updated'
        else
          redirect_back fallback_location: desktop_user_edit_path(user), alert: 'Invalid user information'
        end
      end

      def delete
        user = current_organisation.users.find(params[:id])
        redirect_to desktop_users_path if user == current_user

        user.destroy!
        redirect_to desktop_users_path
      end

      private

      def user_params
        params
          .require(:user)
          .permit(
            :id,
            :first_name,
            :last_name,
            :email,
            :password,
            :phone,
            :weight,
            :notes,
            :address,
            :city,
            :postcode,
            :max_daycare_visits,
            :organisation_id,
            :colour,
            :rewards_points,
            :additional_user_first_name,
            :additional_user_last_name,
            :additional_user_email,
            :additional_user_phone,
            :additional_user_relationship,
            :role
          )
      end
    end
  end
end