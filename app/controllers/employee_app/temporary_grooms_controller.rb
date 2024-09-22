module EmployeeApp
  class TemporaryGroomsController < MobileAppController
    def show
      @temporary_groom = current_user.temporary_grooms.find(params[:id])
    end

    def update
      temporary_groom = current_user.temporary_grooms.find(params[:id])
      temporary_groom.assign_attributes(temporary_groom_params)

      if temporary_groom.save
        redirect_to employee_app_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: employee_app_temporary_groom_path(temporary_groom), alert: 'Invalid groom information'
      end
    end

    private

    def temporary_groom_params
      params.require(:temporary_groom).permit(:owner_name, :pet_name, :date, :time, :owner_notes, :pet_notes, :last_groom, :status)
    end
  end
end