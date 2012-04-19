class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      
      t.string :chargify_handle
      t.integer :cases_max
      t.decimal :extra_case_price
      t.integer :clients_max
      t.integer :storage_max_mb

      t.timestamps
    end
  end
end
