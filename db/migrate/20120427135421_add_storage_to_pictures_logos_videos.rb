class AddStorageToPicturesLogosVideos < ActiveRecord::Migration
  def change
    add_column :pictures, :storage_id, :integer
    add_column :videos,   :storage_id, :integer
    add_column :logos,    :storage_id, :integer
    
    add_index :pictures,  :storage_id
    add_index :videos,    :storage_id
    add_index :logos,     :storage_id    
  end
end
