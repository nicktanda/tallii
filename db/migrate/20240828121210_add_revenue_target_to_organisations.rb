class AddRevenueTargetToOrganisations < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :revenue_target, :integer, default: 0
  end
end
