module Desktop
  class DashboardController < DesktopController
    def index
      @grooms = current_organisation.grooms.joins(pet: :user).order(:date, :time).group_by(&:date)
    end
  end
end