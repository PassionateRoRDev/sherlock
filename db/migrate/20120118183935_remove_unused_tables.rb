class RemoveUnusedTables < ActiveRecord::Migration
  def up
    drop_table :audio_assets
    drop_table :blocks
    drop_table :html_assets
    drop_table :picture_assets
    drop_table :video_assets
  end

  def down
    create_table "audio_assets", :force => true do |t|
      t.integer  "block_id",   :null => false
      t.string   "path",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "blocks", :force => true do |t|
      t.integer  "report_id",                 :null => false
      t.integer  "weight",     :default => 0, :null => false
      t.string   "block_type",                :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "html_assets", :force => true do |t|
      t.integer  "block_id",   :null => false
      t.text     "contents",   :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "picture_assets", :force => true do |t|
      t.integer  "block_id",   :null => false
      t.string   "path",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "video_assets", :force => true do |t|
      t.integer  "block_id",   :null => false
      t.string   "path",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
