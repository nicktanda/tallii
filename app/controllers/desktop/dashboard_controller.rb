module Desktop
  class DashboardController < DesktopController
    def index
      @date = params[:date] ? Date.new(params[:date].split("-").first.to_i, params[:date].split("-").second.to_i, params[:date].split("-").last.to_i) : Date.today

      # Eager load associations to prevent N+1 when accessing pet.name, user.full_name, etc.
      @grooms = current_organisation.grooms.includes(:pet, :user).on_date(@date) +
                current_organisation.temporary_grooms.includes(:user).on_date(@date)
      @daycare_visits = current_organisation.daycare_visits.includes(:pet, :user).on_date(@date) +
                        current_organisation.temporary_daycare_visits.includes(:user).on_date(@date)
      @bookings = (@grooms + @daycare_visits).sort_by(&:start_time)

      # Pre-index grooms by date for efficient calendar lookups (O(1) instead of O(n))
      @grooms_by_date = @grooms.group_by(&:date)

      # Pre-calculate counts for pie charts (avoid multiple iterations)
      @groom_count = @bookings.count { |b| b.is_a?(Groom) || b.is_a?(TemporaryGroom) }
      @daycare_visit_count = @bookings.count { |b| b.is_a?(DaycareVisit) || b.is_a?(TemporaryDaycareVisit) }
      @half_day_count = @bookings.count { |b| (b.is_a?(DaycareVisit) || b.is_a?(TemporaryDaycareVisit)) && b.duration == "half_day" }
      @full_day_count = @bookings.count { |b| (b.is_a?(DaycareVisit) || b.is_a?(TemporaryDaycareVisit)) && b.duration == "full_day" }
    end
  end
end