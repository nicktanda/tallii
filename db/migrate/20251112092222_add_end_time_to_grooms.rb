class AddEndTimeToGrooms < ActiveRecord::Migration[8.0]
  def change
    add_column :grooms, :end_time, :time
  end
end
