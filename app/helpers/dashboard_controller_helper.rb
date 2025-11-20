module DashboardControllerHelper
  def time_conversion(minutes)
    hrs = 0
    min = 0
    min = minutes % 60
    hrs = (minutes - min) / 60
    min = format('%02d',min)
    return "#{hrs}:#{min}"
  end

  def is_in_opening_hours?(time, organisation, day)
    opening_hours = organisation.opening_hours

    return false if opening_hours[day]["closed"] == "true"

    open = Time.parse("2000-01-01 #{opening_hours[day]['open']}")
    close = Time.parse("2000-01-01 #{opening_hours[day]['close']}")
    time >= open && time <= close
  end

  def date_conversion(date, day)
    calculated_date = date.beginning_of_week + day.to_i
    calculated_date.strftime('%Y-%m-%d')
  end

  def spanning?(time, booking)
    booking.start_time >= time && booking.end_time <= time
  end
end
