class AddAlignmentToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :alignment, :string
  end
end
