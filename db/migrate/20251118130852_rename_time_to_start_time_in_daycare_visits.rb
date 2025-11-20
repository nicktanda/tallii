class RenameTimeToStartTimeInDaycareVisits < ActiveRecord::Migration[8.0]
  def change
    rename_column :daycare_visits, :time, :start_time
  end
end
