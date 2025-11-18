class AddEndTimeToTemporaryGrooms < ActiveRecord::Migration[8.0]
  def change
    add_column :temporary_grooms, :end_time, :time
  end
end
