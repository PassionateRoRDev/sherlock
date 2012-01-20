class AddFieldsToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :original_filename, :string
    add_column :pictures, :content_type, :string
  end
end
