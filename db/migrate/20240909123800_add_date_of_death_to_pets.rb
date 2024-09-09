class AddDateOfDeathToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :date_of_death, :date
  end
end
