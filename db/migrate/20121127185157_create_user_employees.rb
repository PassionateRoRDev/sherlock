class CreateUserEmployees < ActiveRecord::Migration  
  def change
    create_table :user_employees do |t|      
      t.references :user
      t.integer :employee_id   
      t.timestamps                  
    end    
    add_index(:user_employees, [:user_id, :employee_id], :unique => true)         
  end
  
end
