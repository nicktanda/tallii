module Desktop
  class GroomsController < DesktopController
    def index
      @grooms = current_organisation.grooms.pending_or_confirmed.order(:date, :time).group_by(&:date)
      @in_progress_grooms = current_organisation.grooms.today.in_progress
      @completed_grooms = current_organisation.grooms.today.completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @groom = current_organisation.grooms.find(params[:id])
    end
  end
end