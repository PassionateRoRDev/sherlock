class AddLogoContentTypeToLetterHead < ActiveRecord::Migration
  def change
    add_column :letterheads, :logo_content_type, :string
  end
end
