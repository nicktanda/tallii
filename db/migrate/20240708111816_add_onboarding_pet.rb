class AddOnboardingPet < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_pets do |t|
      t.string :name, limit: 100
      t.date :dob
      t.string :breed
      t.integer :species
      t.integer :gender
      t.integer :weight
      t.string :health_conditions

      t.references :user, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
