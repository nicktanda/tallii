class RenameTimeToStartTimeInTemporaryDaycareVisits < ActiveRecord::Migration[8.0]
  def change
    rename_column :temporary_daycare_visits, :time, :start_time
  end
end
