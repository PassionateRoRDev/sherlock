class CreateSettings < ActiveRecord::Migration
  
  def change
    create_table :settings do |t|      
      t.integer :non_cc_trial, :null => false, :default => 0
    end
  end
  
end
