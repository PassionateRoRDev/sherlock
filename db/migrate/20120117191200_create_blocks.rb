class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references  :report,      :null => false
      t.integer     :weight,      :null => false, :default => 0
      t.string      :block_type,  :null => false # HTML, PICTURE, VIDEO, AUDIO
      t.timestamps
    end
  end
end
