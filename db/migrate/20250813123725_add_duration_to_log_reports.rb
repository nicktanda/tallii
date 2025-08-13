class AddDurationToLogReports < ActiveRecord::Migration[8.0]
  def change
    add_column :log_reports, :duration, :decimal, precision: 5, scale: 2, default: 0
  end
end
