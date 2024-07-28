module Desktop
  class DaycareVisitsController < DesktopController
    def index
      @daycare_visits = current_organisation.daycare_visits.joins(:pet).pending_or_confirmed.order(:date, :time).group_by(&:date)
      @in_progress_daycare_visits = current_organisation.daycare_visits.joins(:pet).today.in_progress
      @completed_daycare_visits = current_organisation.daycare_visits.joins(:pet).today.completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end
  end
end