class AddStripeApiKeyToOrg < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :stripe_api_key, :text
  end
end
