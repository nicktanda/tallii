module Desktop
  class UsersController < DesktopController
    def index
      @users = current_organisation.users
    end

    def show
      @users = current_organisation.users.active
      @user = current_organisation.users.left_joins(pets: [:grooms, :daycare_visits]).find(params[:id])
      @bookings = @user.pets.map do |pet|
        grooms = pet.grooms.map do |groom|
          { pet: pet.name, time: groom.time, date: groom.date, status: groom.status }
        end
        daycare_visits = pet.daycare_visits.map do |daycare_visit|
          { pet: pet.name, time: daycare_visit.time, date: daycare_visit.date, status: daycare_visit.status }
        end
        (grooms + daycare_visits).sort_by {|booking| [booking[:date], booking[:time]] }
      end.flatten
    end

    def edit
      @users = current_organisation.users
      @user = current_organisation.users.left_joins(pets: [:grooms, :daycare_visits]).find(params[:id])
    end

    def new; end

    def create
      user = current_organisation.users.new(user_params)

      if user.save
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

      user.archive
      redirect_to desktop_users_path
    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :phone, :weight, :address, :city, :postcode)
    end
  end
end