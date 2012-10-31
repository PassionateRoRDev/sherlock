class AddConfirmableToDevise < ActiveRecord::Migration
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at,       :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_index  :users, :confirmation_token, :unique => true  
    
    User.reset_column_information
    User.all.each do |u| 
      u.confirmed_at = u.created_at
      u.save
    end
    
  end
  
  def down
    
  end
end
