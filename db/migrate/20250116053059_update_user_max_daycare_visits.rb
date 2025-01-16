class UpdateUserMaxDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :max_daycare_visits, :integer, default: 10
    User.all.update!(max_daycare_visits: 10)
  end
end
