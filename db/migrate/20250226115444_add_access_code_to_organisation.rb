class AddAccessCodeToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :access_code, :string, unique: true
    Organisation.all.each do |organisation|
      organisation.send(:generate_unique_code) if organisation.access_code.blank?
    end
    change_column_null :organisations, :access_code, false
  end
end
