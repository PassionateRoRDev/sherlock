class CreateHtmlAssets < ActiveRecord::Migration
  def change
    create_table :html_assets do |t|
      t.references :block, :null => false
      t.text :contents, :null => false
      t.timestamps
    end
  end
end
