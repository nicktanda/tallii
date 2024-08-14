module Desktop
  module Users
    class EmployeesController < DesktopController
      before_action :users, only: [:index, :show, :edit]

      def index; end

      def show
        @user = current_organisation.users.customers.left_joins(pets: [:grooms, :daycare_visits]).find(params[:id])
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
        @user = current_organisation.users.customers.left_joins(pets: [:grooms, :daycare_visits]).find(params[:id])
      end

      def new; end

      private

      def users
        @users ||= current_organisation.users.customers
      end
    end
  end
end