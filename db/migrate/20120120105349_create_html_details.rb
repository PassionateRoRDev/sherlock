class CreateHtmlDetails < ActiveRecord::Migration
  def change
    create_table :html_details do |t|
      t.references :block, :null => false
      t.text :contents, :null => false
      t.timestamps
    end
  end
end
