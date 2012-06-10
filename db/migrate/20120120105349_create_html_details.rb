class CreateHtmlDetails < ActiveRecord::Migration
  def change
    create_table :html_details do |t|
      t.references :block, :null => false
      t.text :contents, :null => false, :limit => 64.kilobytes + 1
      t.timestamps
    end
  end
end
