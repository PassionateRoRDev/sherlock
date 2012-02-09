class CreateLetterheads < ActiveRecord::Migration
  def change
    create_table :letterheads do |t|
      
      t.references :user, :null => false
      
      t.boolean :all_pages, :null => false, :default => false
      t.boolean :link,  :null => false, :default => false
      
      t.string :alignment, :null => false, :default => :left
      t.string :bgcolor
      t.boolean :border, :null => false, :default => false
      
      t.string :font_face
      t.integer :font_size
      t.string :font_color
      
      t.boolean :divider, :null => false, :default => false
      t.integer :divider_size
      t.integer :divider_width
      t.string :divider_color
      t.text :contents
      t.string :logo_path
      t.string :logo_alignment, :null => false, :default => :left

      t.timestamps
    end
  end
end
