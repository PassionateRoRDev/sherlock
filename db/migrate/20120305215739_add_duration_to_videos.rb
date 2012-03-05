class AddDurationToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :duration, :int
  end
end
