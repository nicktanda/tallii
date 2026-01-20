class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # Composite indexes for common queries filtering by organisation_id and date
    add_index :grooms, [:organisation_id, :date], name: 'index_grooms_on_organisation_id_and_date'
    add_index :temporary_grooms, [:organisation_id, :date], name: 'index_temporary_grooms_on_organisation_id_and_date'
    add_index :daycare_visits, [:organisation_id, :date], name: 'index_daycare_visits_on_organisation_id_and_date'
    add_index :temporary_daycare_visits, [:organisation_id, :date], name: 'index_temporary_daycare_visits_on_organisation_id_and_date'

    # Composite indexes for status + date queries (pending_or_confirmed.on_date)
    add_index :grooms, [:organisation_id, :status, :date], name: 'index_grooms_on_org_status_date'
    add_index :temporary_grooms, [:organisation_id, :status, :date], name: 'index_temporary_grooms_on_org_status_date'
    add_index :daycare_visits, [:organisation_id, :status, :date], name: 'index_daycare_visits_on_org_status_date'
    add_index :temporary_daycare_visits, [:organisation_id, :status, :date], name: 'index_temporary_daycare_visits_on_org_status_date'

    # Index for user phone lookups (used in imports and customer search)
    add_index :users, [:organisation_id, :phone], name: 'index_users_on_organisation_id_and_phone'

    # Index for pet lookups by user
    add_index :pets, :user_id, name: 'index_pets_on_user_id', if_not_exists: true
  end
end
