class CreateUserClients < ActiveRecord::Migration
  def change
    create_table :user_clients do |t|      
      t.references :user
      t.integer :client_id      
      t.timestamps                  
    end    
    add_index(:user_clients, [:user_id, :client_id], :unique => true)         
  end
    
  
end
