class GroomAndDaycareVisitSettingsOnOrg < ActiveRecord::Migration[7.0]
  def change
    remove_column :organisations, :maximum_grooms
    remove_column :organisations, :maximum_visits
    
    add_column :organisations, :maximum_weekly_grooms, :integer, default: 0
    add_column :organisations, :maximum_daily_grooms, :integer, default: 0
    
    add_column :organisations, :maximum_weekly_daycare_visits, :integer, default: 0
    add_column :organisations, :maximum_daily_daycare_visits, :integer, default: 0
  end
end
