class AddRewardPointSettingsToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :grooming_reward_points, :integer, default: 0
    add_column :organisations, :daycare_visit_reward_points, :integer, default: 0
  end
end
