module Desktop
  class GroomsController < DesktopController
    def index
      @grooms = current_organisation.grooms.joins(:pet).pending_or_confirmed.order(:date, :time).group_by(&:date)
      @in_progress_grooms = current_organisation.grooms.joins(:pet).today.in_progress
      @completed_grooms = current_organisation.grooms.joins(:pet).today.completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end
  end
end