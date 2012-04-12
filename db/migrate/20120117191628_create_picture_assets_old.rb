class CreatePictureAssetsOld < ActiveRecord::Migration
  def change
    create_table :picture_assets do |t|
      t.references :block, :null => false
      t.string :path, :null => false
      t.timestamps
    end
  end
end
