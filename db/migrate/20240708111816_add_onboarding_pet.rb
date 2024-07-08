class AddOnboardingPet < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_pets do |t|
      t.string :name, null: false, limit: 100
      t.date :dob, null: false
      t.string :breed, null: false
      t.integer :species, default: 0, null: false
      t.integer :gender, default: 0, null: false
      t.integer :weight, default: 0, null: false
      t.string :health_conditions, null: false

      t.references :user, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
