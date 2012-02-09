class CreateFooters < ActiveRecord::Migration
  def change
    create_table :footers do |t|
      
      t.references :case
      
      t.boolean :all_pages, :null => false, :default => false
      t.boolean :link
      
      t.string :alignment, :null => false, :default => :left
      t.string :bgcolor
      t.boolean :border, :null => false, :default => false
      
      t.string :font_face
      t.integer :font_size
      t.string :font_color
      
      t.boolean :divider_above, :null => false, :default => false
      t.integer :divider_size
      t.integer :divider_width
      t.string :divider_color
      
      t.text :contents      
      t.string :text_align, :null => false, :default => :left
      
      t.boolean :divider_below, :null => false, :default => false

      t.timestamps
    end
  end
end
