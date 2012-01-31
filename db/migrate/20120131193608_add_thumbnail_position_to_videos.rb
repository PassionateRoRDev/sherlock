class AddThumbnailPositionToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :thumbnail_pos, :string
  end
end
