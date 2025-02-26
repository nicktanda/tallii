class AddOnboardingUserAccessCode < ActiveRecord::Migration[7.0]
  def change
    remove_reference :onboarding_users, :organisation, foreign_key: true
    add_column :onboarding_users, :access_code, :string
  end
end
