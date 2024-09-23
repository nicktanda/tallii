module EmployeeApp
  class GroomsController < MobileAppController
    def index
      @grooms = current_user.grooms.pending_or_confirmed.today.order(:time) + current_user.temporary_grooms.pending_or_confirmed.today.order(:time)
      @in_progress_grooms = current_user.grooms.in_progress.today.order(:time) + current_user.temporary_grooms.in_progress.today.order(:time)
      @completed_grooms = current_user.grooms.missed_appointment_or_completed.today.order(:time) + current_user.temporary_grooms.missed_appointment_or_completed.today.order(:time)
    end

    def show
      @groom = current_user.grooms.find(params[:id])
    end

    def update
      groom = current_user.grooms.find(params[:id])
      groom.assign_attributes(groom_params)
  
      if groom.save
        redirect_to employee_app_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: employee_app_groom_path(groom), alert: 'Invalid groom information'
      end
    end

    private

    def groom_params
      params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :status)
    end
  end
end