class AddAlignmentToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :alignment, :string
  end
end
