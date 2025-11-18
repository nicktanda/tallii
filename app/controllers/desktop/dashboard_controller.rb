module Desktop
  class DashboardController < DesktopController
    def index
      @date = params[:date] ? Date.new(params[:date].split("-").first.to_i, params[:date].split("-").second.to_i, params[:date].split("-").last.to_i) : Date.today
      @grooms = current_organisation.grooms.on_date(@date) + current_organisation.temporary_grooms.on_date(@date)
      @daycare_visits = current_organisation.daycare_visits.on_date(@date) + current_organisation.temporary_daycare_visits.on_date(@date)
      @bookings = (@grooms + @daycare_visits).sort_by(&:start_time)
    end
  end
end