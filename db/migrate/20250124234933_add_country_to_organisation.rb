class AddCountryToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :country, :text
  end
end
