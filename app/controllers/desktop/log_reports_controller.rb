module Desktop
  class LogReportsController < DesktopController
    def create
      booking_type = params[:log_report][:booking_type]

      booking = if booking_type == "Groom"
        current_organisation.grooms.find(params[:id])
      elsif booking_type == "TemporaryGroom"
        current_organisation.temporary_grooms.find(params[:id])
      elsif booking_type == "DaycareVisit"
        current_organisation.daycare_visits.find(params[:id])
      else
        current_organisation.temporary_daycare_visits.find(params[:id])
      end

      log_report = booking.create_log_report(log_report_params)
      save_result = log_report.save! ? "Log report successfully created" : "Invalid log report"
      redirect_path = if booking.is_a?(Groom) || booking.is_a?(TemporaryGroom)
        desktop_grooms_path(date: booking.date)
      else
        desktop_daycare_visits_path(date: booking.date)
      end
      redirect_to redirect_path, alert: save_result
    end

    def update
      booking_type = params[:log_report][:booking_type]

      booking = if booking_type == "Groom"
        current_organisation.grooms.find(params[:id])
      elsif booking_type == "TemporaryGroom"
        current_organisation.temporary_grooms.find(params[:id])
      elsif booking_type == "DaycareVisit"
        current_organisation.daycare_visits.find(params[:id])
      else
        current_organisation.temporary_daycare_visits.find(params[:id])
      end

      save_result = booking.log_report.update!(log_report_params) ? "Log report successfully updated" : "Invalid log report update"
      redirect_path = if booking.is_a?(Groom) || booking.is_a?(TemporaryGroom)
        desktop_grooms_path(date: booking.date)
      else
        desktop_daycare_visits_path(date: booking.date)
      end
      redirect_to redirect_path, alert: save_result
    end

    private

    def log_report_params
      params
        .require(:log_report)
        .permit(
          :org_notes,
          :customer_notes,
          :price,
          :payment_method,
          :duration
        )
    end
  end
end