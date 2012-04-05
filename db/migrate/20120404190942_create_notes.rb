class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      
      t.references :case
      t.text :contents

      t.timestamps
    end
    add_index :notes, :case_id
  end
end
