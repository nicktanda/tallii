class AddDepositFieldsToGrooms < ActiveRecord::Migration[8.0]
  def change
    add_column :grooms, :deposit, :float
    add_column :grooms, :deposit_method, :integer
  end
end
