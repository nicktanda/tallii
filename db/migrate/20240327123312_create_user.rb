class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 100
      t.string :email, null: false, limit: 100
      t.string :password_digest, null: false

      t.references :organisation, null: false, foreign_key: true
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
