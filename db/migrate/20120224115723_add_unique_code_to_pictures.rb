class AddUniqueCodeToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :unique_code, :string, :unique => true
  end
end
