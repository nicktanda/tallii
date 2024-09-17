module EmployeeApp
  class GroomsController < MobileAppController
    def index
      @grooms = (current_user.grooms.pending_or_confirmed.order(:date, :time) + current_user.temporary_grooms.pending_or_confirmed.order(:date, :time)).group_by(&:date)
      @in_progress_grooms = current_user.grooms.order(:date, :time).in_progress + current_user.temporary_grooms.order(:date, :time).in_progress
      @completed_grooms = current_user.grooms.order(:date, :time).completed + current_user.temporary_grooms.order(:date, :time).completed
    end

    def show

    end

    def update

    end
  end
end