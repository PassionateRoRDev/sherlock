class CasesHaveManyUsers < ActiveRecord::Migration
  def up
    rename_column :cases, :user_id, :author_id

    create_table :viewers, :id => false do |t|
      t.integer :case_id
      t.integer :viewer_id
    end
  end

  def down
    drop_table :cases_users
    rename_column :cases, :author_id, :user_id
  end
end
