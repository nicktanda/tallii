module Desktop
  class UsersController < DesktopController
    def index
      @users = current_organisation.users
    end

    def show
      @users = current_organisation.users
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

    def new; end

    def create
      user = current_organisation.users.new(user_params)

      if user.save
        redirect_to desktop_user_path(user)
      else
        redirect_back fallback_location: desktop_users_new_path, alert: 'Invalid email'
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :weight, :address, :city, :postcode)
    end
  end
end