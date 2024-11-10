class AddOnboardingUser < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :address
      t.string :city
      t.string :postcode

      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
