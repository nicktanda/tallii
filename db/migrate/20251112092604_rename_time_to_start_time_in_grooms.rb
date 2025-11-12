class RenameTimeToStartTimeInGrooms < ActiveRecord::Migration[8.0]
  def change
    rename_column :grooms, :time, :start_time
  end
end
