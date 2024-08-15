class AddEmployeesToGroomsAndDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :grooms, :employee_id, :bigint, null: false
    add_foreign_key :grooms, :users, column: :employee_id
    add_index :grooms, :employee_id

    add_column :daycare_visits, :employee_id, :bigint, null: false
    add_foreign_key :daycare_visits, :users, column: :employee_id
    add_index :daycare_visits, :employee_id
  end
end
