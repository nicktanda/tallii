class AddRewardPointsToLogReports < ActiveRecord::Migration[8.0]
  def change
    add_column :log_reports, :reward_points, :integer, default: 0
  end
end
