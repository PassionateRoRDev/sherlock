class CreateWitnessStatement < ActiveRecord::Migration
  def change
    
    create_table :witness_statements do |t|
      
      t.references :block
      
      t.string :day
      t.string :hour
      
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      
      t.string :contents, :limit => 64.kilobytes + 1
      
      t.timestamps
      
    end
    
  end 
end
