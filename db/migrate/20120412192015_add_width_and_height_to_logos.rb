class AddWidthAndHeightToLogos < ActiveRecord::Migration
  def change
    add_column :logos, :width, :int

    add_column :logos, :height, :int

  end
end
