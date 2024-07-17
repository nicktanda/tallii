module Desktop
  class DashboardController < DesktopController
    def index
      @grooms = current_organisation.grooms.joins(pet: :user).order(:date, :time).group_by(&:date)
      @daycare_visits = current_organisation.daycare_visits.today
    end
  end
end