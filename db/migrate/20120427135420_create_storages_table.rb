class CreateStoragesTable < ActiveRecord::Migration
  def change
    create_table :storages do |t|      
      t.string  :mount_point
      t.integer :size      
    end
  end 
end
