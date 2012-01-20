class CreateBlocksAgain < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references  :case,      :null => false
      t.integer     :weight,      :null => false, :default => 0      
      t.timestamps
    end
  end  
end
