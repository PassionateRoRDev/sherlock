class ChangeHeaderAndFooterLinkType < ActiveRecord::Migration
  def up
    change_column :letterheads, :link, :string
    change_column :footers, :link, :string
  end

  def down
    change_column :letterheads, :link, :boolean, :null => false, :default => false
    change_column :footers, :link,  :boolean, :null => false, :default => false
  end
end
