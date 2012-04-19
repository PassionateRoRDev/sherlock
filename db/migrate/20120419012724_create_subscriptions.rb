class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      
      t.string :chargify_id
      t.string :product_handle
      
      t.references :user
      t.references :subscription_plan
      
      t.datetime :period_ends_at
      t.datetime :next_assessment_at
      
      t.string :status
      
      t.integer :cases_max
      t.integer :cases_count
      
      t.decimal :extra_case_price
      t.integer :extra_cases_count
      
      t.integer :clients_max
      t.integer :clients_count
      
      t.integer :storage_max_mb

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :subscription_plan_id
  end
end
