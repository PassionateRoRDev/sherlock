class AddTitleAlignmentToCases < ActiveRecord::Migration
  def change
    add_column :cases, :title_alignment, :string
  end
end
