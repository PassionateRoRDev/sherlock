class CreateFolders < ActiveRecord::Migration
  def up
    create_table :folders do |t|      
      t.string :title
      t.references :user
      t.timestamps
    end    
    add_column :cases, :folder_id, :int   
  end
  
  def down
    remove_column :cases, :folder_id    
    drop_table :folders   
  end
end
