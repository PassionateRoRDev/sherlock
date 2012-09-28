class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      
      t.string      :title
      t.string      :original_filename
      t.references  :case
      t.references  :storage
      
    end
  end
end
