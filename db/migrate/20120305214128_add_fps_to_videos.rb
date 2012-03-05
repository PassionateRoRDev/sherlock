class AddFpsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :fps, :float
  end
end
