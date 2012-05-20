class CreateCapturedEmails < ActiveRecord::Migration
  def change

    create_table :captured_emails do |t|
        t.string  :email, :null => false, :unique => true
        t.string  :ip        
        t.timestamps        
      end    
  end
  
end
