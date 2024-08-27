module Desktop
  class DaycareVisitsController < DesktopController
    def index
      @daycare_visits = current_organisation.daycare_visits.pending_or_confirmed.order(:date, :time).group_by(&:date)
      @in_progress_daycare_visits = current_organisation.daycare_visits.order(:date, :time).in_progress
      @completed_daycare_visits = current_organisation.daycare_visits.order(:date, :time).completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @daycare_visit = current_organisation.daycare_visits.find(params[:id])
    end

    def update
      daycare_visit = current_organisation.daycare_visits.find(params[:id])
      daycare_visit.assign_attributes(daycare_visit_params)

      if daycare_visit.save
        redirect_to desktop_daycare_visits_path, notice: 'Daycare visit updated successfully'
      else
        redirect_back fallback_location: desktop_daycare_visit_path(daycare_visit), alert: 'Invalid daycare visit information'
      end
    end

    def update_settings
      current_organisation.assign_attributes(daycare_visit_settings_params)

      if current_organisation.save
        redirect_to desktop_organisation_settings_path, notice: 'Daycare Visit settings updated successfully'
      else
        redirect_to desktop_organisation_settings_path, notice: 'Invalid settings'
      end
    end

    private

    def daycare_visit_params
      params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration, :employee_id, :status)
    end

    def daycare_visit_settings_params
      params.permit(:maximum_weekly_daycare_visits, :maximum_daily_daycare_visits)
    end
  end
end