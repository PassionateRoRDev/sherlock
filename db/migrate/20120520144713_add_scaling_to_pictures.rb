class AddScalingToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :scaling, :integer
  end
end
