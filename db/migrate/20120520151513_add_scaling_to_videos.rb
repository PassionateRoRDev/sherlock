class AddScalingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :scaling, :integer

  end
end
