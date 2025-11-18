class RenameTimeToStartTimeInTemporaryGrooms < ActiveRecord::Migration[8.0]
  def change
    rename_column :temporary_grooms, :time, :start_time
  end
end
