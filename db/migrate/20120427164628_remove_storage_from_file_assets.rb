class RemoveStorageFromFileAssets < ActiveRecord::Migration
  def up
    remove_column :file_assets, :storage
  end

  def down
    add_column :file_assets, :storage, :string
  end
end
