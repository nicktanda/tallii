class AddOpeningHoursToOrganisations < ActiveRecord::Migration[8.0]
  def change
    add_column :organisations, :opening_hours, :text
  end
end
