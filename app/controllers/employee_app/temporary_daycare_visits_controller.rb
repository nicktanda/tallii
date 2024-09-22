module EmployeeApp
  class TemporaryDaycareVisitsController < MobileAppController
    def show
      @temporary_daycare_visit = current_user.temporary_daycare_visits.find(params[:id])
    end

    def update
      temporary_daycare_visit = current_user.temporary_daycare_visits.find(params[:id])
      temporary_daycare_visit.assign_attributes(temporary_daycare_visit_params)

      if temporary_daycare_visit.save
        redirect_to employee_app_daycare_visits_path, notice: 'Daycare visit updated successfully'
      else
        redirect_back fallback_location: employee_app_daycare_visit_path(temporary_daycare_visit), alert: 'Invalid daycare visit information'
      end
    end

    private

    def temporary_daycare_visit_params
      params.require(:temporary_daycare_visit).permit(:pet_name, :owner_name, :date, :time, :pet_notes, :owner_notes, :duration, :status)
    end
  end
end