class AddImageReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :user, foreign_key: true
  end
end
