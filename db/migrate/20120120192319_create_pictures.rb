class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      # we may relax it to nullable and add user reference to have
      # support for pics not associated with any blocks/cases
      t.references :block, :null => false
      t.string :title
      t.string :path, :null => false
      t.timestamps
    end
  end
end
