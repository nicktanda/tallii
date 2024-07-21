class AddDaycareStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :daycare_visits, :status, :integer, default: 0
  end
end
