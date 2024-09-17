module EmployeeApp
  class GroomsController < MobileAppController
    def index
      @grooms = current_user.grooms.pending_or_confirmed.today.order(:time) + current_user.temporary_grooms.pending_or_confirmed.today.order(:time)
      @in_progress_grooms = current_user.grooms.in_progress.today.order(:time) + current_user.temporary_grooms.in_progress.today.order(:time)
      @completed_grooms = current_user.grooms.completed.today.order(:time) + current_user.temporary_grooms.completed.today.order(:time)
    end

    def show

    end

    def update

    end
  end
end