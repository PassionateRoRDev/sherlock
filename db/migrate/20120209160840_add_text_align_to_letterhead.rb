class AddTextAlignToLetterhead < ActiveRecord::Migration
  def change
    add_column :letterheads, :text_align, :string, :null => false, :default => :left
  end
end
