module Desktop
  class TemporaryDaycareVisitsController < DesktopController
    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @temporary_daycare_visit = current_organisation.temporary_daycare_visits.find(params[:id])
    end

    def create
      temporary_daycare_visit = current_organisation.temporary_daycare_visits.new(temporary_daycare_visit_params)
  
      if current_organisation.daycare_visits_today_count == current_organisation.maximum_daily_daycare_visits
        redirect_back fallback_location: desktop_temporary_daycare_visits_new_path, alert: 'We are unable to take any extra daycare visits today, please rebook for another day'
        return
      end
  
      if current_organisation.daycare_visits_this_week_count == current_organisation.maximum_weekly_daycare_visits
        redirect_back fallback_location: desktop_temporary_daycare_visits_new_path, alert: 'We are unable to take any extra daycare visits this week, please rebook for another week'
        return
      end
  
      if temporary_daycare_visit.save
        redirect_to desktop_daycare_visits_path, notice: 'Daycare visit created successfully'
      else
        redirect_back fallback_location: new_temporary_daycare_visits_path, alert: 'Invalid daycare visit information'
      end
    end

    def update
      temporary_daycare_visit = current_organisation.temporary_daycare_visits.find(params[:id])
      temporary_daycare_visit.assign_attributes(temporary_daycare_visit_params)

      if temporary_daycare_visit.save
        redirect_to desktop_daycare_visits_path, notice: 'Daycare visit updated successfully'
      else
        redirect_back fallback_location: desktop_temporary_daycare_visit_path(temporary_daycare_visit), alert: 'Invalid daycare visit information'
      end
    end

    private

    def temporary_daycare_visit_params
      params.require(:temporary_daycare_visit).permit(:pet_name, :owner_name, :date, :time, :pet_notes, :owner_notes, :duration, :employee_id, :status)
    end
  end
end