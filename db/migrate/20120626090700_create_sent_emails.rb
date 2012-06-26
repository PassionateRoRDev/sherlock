class CreateSentEmails < ActiveRecord::Migration
  def change
    create_table :sent_emails do |t|
      
      # some emails can be at user level, some at the subscription level
      t.references  :user
      t.references  :subscription
      
      t.string      :label, :null => false
      
      t.timestamps
      
    end    
  end
end
