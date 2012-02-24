class CreateLogosAsResources < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      
      t.references :user, :null => false
      t.references :letterhead
      
      t.string :path, :null => false
      t.string :content_type, :null => false      
      
      t.timestamps
    end        
    
  end    
  
end
