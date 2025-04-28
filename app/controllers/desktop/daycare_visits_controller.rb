module Desktop
  class DaycareVisitsController < DesktopController
    def index
      @date = params[:date] ? Date.new(params[:date].split("-").first.to_i, params[:date].split("-").second.to_i, params[:date].split("-").last.to_i) : Date.today

      @daycare_visits = current_organisation.daycare_visits.pending_or_confirmed.on_date(@date).order(:date, :time) + current_organisation.temporary_daycare_visits.pending_or_confirmed.on_date(@date).order(:date, :time)
      @in_progress_daycare_visits = current_organisation.daycare_visits.order(:date, :time).in_progress.on_date(@date) + current_organisation.temporary_daycare_visits.order(:date, :time).in_progress.on_date(@date)
      @completed_daycare_visits = current_organisation.daycare_visits.order(:date, :time).missed_appointment_or_completed.on_date(@date) + current_organisation.temporary_daycare_visits.order(:date, :time).missed_appointment_or_completed.on_date(@date)

      @unscoped_daycare_visits = current_organisation.daycare_visits.on_date(@date).order(:date, :time) + current_organisation.temporary_daycare_visits.on_date(@date).order(:date, :time)
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
        redirect_to desktop_daycare_visits_path(date: daycare_visit.date), notice: 'Daycare visit updated successfully'
      else
        redirect_back fallback_location: desktop_daycare_visits_path, alert: 'Invalid daycare visit information'
      end
    end

    private

    def daycare_visit_params
      params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration, :employee_id, :status)
    end
  end
end