class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      # we may relax it to nullable and add user reference to have
      # support for pics not associated with any blocks/cases
      t.references :block, :null => false
      t.string :title
      t.string :path, :null => false
      t.string :original_filename
      t.string :content_type
      t.timestamps
    end
  end
end
