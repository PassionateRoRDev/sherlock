class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title, :null => false
      t.references :user, :null => false
      t.timestamps
    end
  end
end
