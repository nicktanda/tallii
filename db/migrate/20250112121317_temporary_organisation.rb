class TemporaryOrganisation < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_organisations do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.string :postcode
      t.string :user_name
      t.string :user_password

      t.timestamps
    end
  end
end