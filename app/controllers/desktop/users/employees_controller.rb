module Desktop
  module Users
    class EmployeesController < DesktopController
      before_action :users

      def index; end

      def show
        @user = users.find(params[:id])

        bookings = @user.pets.map do |pet|
          grooms = pet.grooms.map do |groom|
            { pet: pet.name, time: groom.start_time, date: groom.date, status: groom.status }
          end
          daycare_visits = pet.daycare_visits.map do |daycare_visit|
            { pet: pet.name, time: daycare_visit.start_time, date: daycare_visit.date, status: daycare_visit.status }
          end
          (grooms + daycare_visits)
        end.flatten

        temporary_bookings = @user.temporary_grooms + @user.temporary_daycare_visits

        @bookings = (bookings + temporary_bookings).sort_by {|booking| [booking[:date], booking[:time]] }.flatten
      end

      def edit
        @user = users.find(params[:id])
      end

      def new; end

      private

      def users
        @users ||= current_organisation.users.employees_and_admins
      end
    end
  end
end