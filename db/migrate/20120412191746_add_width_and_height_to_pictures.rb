class AddWidthAndHeightToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :width, :int
    add_column :pictures, :height, :int
  end
end
