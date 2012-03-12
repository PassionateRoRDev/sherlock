class CreateUserAddresses < ActiveRecord::Migration
  def change
    create_table :user_addresses do |t|
            
      t.references :user, :null => false
      
      t.string :address 
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.string :phone
      
      t.timestamps
      
    end
  end

end
