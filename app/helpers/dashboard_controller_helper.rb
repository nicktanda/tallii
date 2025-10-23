module DashboardControllerHelper
  def time_conversion(minutes)
    hrs = 0
    min = 0
    min = minutes % 60
    hrs = (minutes - min) / 60
    min = format('%02d',min)
    return "#{hrs}:#{min}"
  end
end
