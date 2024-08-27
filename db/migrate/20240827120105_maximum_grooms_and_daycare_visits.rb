class MaximumGroomsAndDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :max_grooms, :integer, default: 0
    add_column :users, :max_daycare_visits, :integer, default: 0
  end
end
