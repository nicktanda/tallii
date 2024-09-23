module Desktop
  class DaycareVisitsController < DesktopController
    def index
      @daycare_visits = (current_organisation.daycare_visits.pending_or_confirmed.order(:date, :time) + current_organisation.temporary_daycare_visits.pending_or_confirmed.order(:date, :time)).group_by(&:date)
      @in_progress_daycare_visits = current_organisation.daycare_visits.order(:date, :time).in_progress + current_organisation.temporary_daycare_visits.order(:date, :time).in_progress
      @completed_daycare_visits = (current_organisation.daycare_visits.order(:date, :time).missed_appointment_or_completed + current_organisation.temporary_daycare_visits.order(:date, :time).missed_appointment_or_completed)
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

    private

    def daycare_visit_params
      params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration, :employee_id, :status)
    end
  end
end