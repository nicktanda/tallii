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

    open = Time.parse(opening_hours[day]["open"])
    close = Time.parse(opening_hours[day]["close"])
    time >= open && time <= close
  end
end
