class RemoveDefaultForLinkField < ActiveRecord::Migration
  def up    
    change_column :letterheads, :link, :string, :null => true
    change_column_default :letterheads, :link, nil
    
    change_column :footers, :link, :string, :null => true
    change_column_default :footers, :link, nil
  end
    
  def down
    change_column :letterheads, :link, :string, :null => false, :default => '0'
    change_column :footers, :link, :string, :null => false, :default => '0'    
  end
end
