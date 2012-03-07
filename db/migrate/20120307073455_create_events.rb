class CreateEvents < ActiveRecord::Migration
  
  def change
    create_table :events do |t|
      
      t.string  :event_type
      t.string  :event_subtype
      t.string  :detail_s1
      t.integer :detail_i1
      
      t.integer :started_at
      t.integer :finished_at
      t.integer :duration
      
      t.timestamps
    end        
    
  end 
  
end
