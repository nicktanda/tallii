module Desktop
  class DashboardController < DesktopController
    def index
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @grooms = current_organisation.grooms.on_date(@date) + current_organisation.temporary_grooms.on_date(@date)
      @daycare_visits = current_organisation.daycare_visits.on_date(@date) + current_organisation.temporary_daycare_visits.on_date(@date)
      @bookings = (@grooms + @daycare_visits).sort_by(&:start_time)
    rescue ArgumentError
      @date = Date.today
      @grooms = current_organisation.grooms.on_date(@date) + current_organisation.temporary_grooms.on_date(@date)
      @daycare_visits = current_organisation.daycare_visits.on_date(@date) + current_organisation.temporary_daycare_visits.on_date(@date)
      @bookings = (@grooms + @daycare_visits).sort_by(&:start_time)
    end
  end
end