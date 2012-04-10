class AddDetailS2ToEvents < ActiveRecord::Migration
  def change
    add_column :events, :detail_s2, :string
  end
end
