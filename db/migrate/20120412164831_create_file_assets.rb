class CreateFileAssets < ActiveRecord::Migration
  def change
    create_table :file_assets do |t|
      
      t.integer :parent_id
      
      # video, picture, logo; a thumbnail image would still have parent_type 'video'
      t.string  :parent_type
      
      t.references :user
      
      # for pictures: main, orig, backup
      t.string  :role      
            
      # for videos: flv, mpg      
      t.string  :format
      t.string  :content_type
                        
      t.integer :filesize
      t.string  :path
      t.string  :storage                  
    end
    
    add_index :file_assets, :parent_id
    
  end
end
