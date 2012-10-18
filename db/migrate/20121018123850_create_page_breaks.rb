class CreatePageBreaks < ActiveRecord::Migration
  def change   
    create_table :page_breaks do |t|      
      t.references  :block, :null => false
      t.boolean     :with_header, :null => false, :default => false      
      t.timestamps      
    end    
    
  end 
end
