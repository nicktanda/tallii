class ChangeColumnDefaultForMaxDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :max_daycare_visits, 10
  end
end
