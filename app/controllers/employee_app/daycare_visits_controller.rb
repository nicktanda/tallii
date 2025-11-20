module EmployeeApp
  class DaycareVisitsController < MobileAppController
    def index
      @daycare_visits = current_user.daycare_visits.pending_or_confirmed.today.order(:start_time) + current_user.temporary_daycare_visits.pending_or_confirmed.today.order(:start_time)
      @in_progress_daycare_visits = current_user.daycare_visits.in_progress.today.order(:start_time) + current_user.temporary_daycare_visits.in_progress.today.order(:start_time)
      @completed_daycare_visits = current_user.daycare_visits.missed_appointment_or_completed.today.order(:start_time) + current_user.temporary_daycare_visits.missed_appointment_or_completed.today.order(:start_time)
    end

    def show
      @daycare_visit = current_user.daycare_visits.find(params[:id])
    end

    def update
      daycare_visit = current_user.daycare_visits.find(params[:id])
      daycare_visit.assign_attributes(daycare_visit_params)

      if daycare_visit.save
        redirect_to employee_app_daycare_visits_path, notice: 'Daycare visit updated successfully'
      else
        redirect_back fallback_location: employee_app_daycare_visit(daycare_visit), alert: 'Invalid daycare visit information'
      end
    end

    private

    def daycare_visit_params
      params.require(:daycare_visit).permit(:date, :start_time, :notes, :pet_id, :duration, :status)
    end
  end
end