class RenameDividerToDividerAbove < ActiveRecord::Migration
  def up
    rename_column(:letterheads, :divider, :divider_above)
  end

  def down
    rename_column(:letterheads, :divider_above, :divider)
  end
end
