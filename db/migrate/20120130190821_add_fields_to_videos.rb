class AddFieldsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :width, :integer
    add_column :videos, :height, :integer
    add_column :videos, :thumbnail, :string
    add_column :videos, :type, :string
    add_column :videos, :filename, :string
  end
end
