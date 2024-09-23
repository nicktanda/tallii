class AddRewardsPointsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :rewards_points, :integer, default: 0
  end
end
