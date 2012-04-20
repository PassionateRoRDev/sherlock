class CreatePurchases < ActiveRecord::Migration

    def change
      
      create_table :purchases do |t|
        t.string      :label
        t.references  :user
        t.decimal     :amount
        t.datetime    :used_at
        t.integer     :used_by_case_id   
        
        t.timestamps
        
      end
      
      add_index :purchases, :user_id
      add_index :purchases, :used_by_case_id
      
    end

end
