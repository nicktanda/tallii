module EmployeeApp
  class DaycareVisitsController < MobileAppController
    def index
      @daycare_visits = (current_user.daycare_visits.pending_or_confirmed.order(:date, :time) + current_user.temporary_daycare_visits.pending_or_confirmed.order(:date, :time)).group_by(&:date)
      @in_progress_daycare_visits = current_user.daycare_visits.order(:date, :time).in_progress + current_user.temporary_daycare_visits.order(:date, :time).in_progress
      @completed_daycare_visits = (current_user.daycare_visits.order(:date, :time).completed + current_user.temporary_daycare_visits.order(:date, :time).completed)
    end

    def show

    end

    def update

    end
  end
end