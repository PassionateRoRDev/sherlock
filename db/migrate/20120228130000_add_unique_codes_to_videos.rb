class AddUniqueCodesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :unique_code, :string, :unique => true
  end
end
