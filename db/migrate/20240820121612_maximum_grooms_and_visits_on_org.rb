class MaximumGroomsAndVisitsOnOrg < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :maximum_grooms, :integer, default: 0
    add_column :organisations, :maximum_visits, :integer, default: 0
  end
end
