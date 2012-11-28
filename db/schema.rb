# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121127185157) do

  create_table "blocked_ips", :force => true do |t|
    t.string   "ip",         :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blocks", :force => true do |t|
    t.integer  "case_id",                   :null => false
    t.integer  "weight",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "captured_emails", :force => true do |t|
    t.string   "email",          :null => false
    t.string   "ip"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "report_sent_at"
  end

  create_table "cases", :force => true do |t|
    t.string   "title",                              :null => false
    t.integer  "author_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.string   "client_name"
    t.date     "opened_on"
    t.date     "closed_on"
    t.text     "summary"
    t.string   "title_alignment"
    t.date     "report_date"
    t.string   "case_type"
    t.integer  "folder_id"
    t.boolean  "is_static",       :default => false
  end

  create_table "data_log_details", :force => true do |t|
    t.integer  "block_id",                       :null => false
    t.string   "day"
    t.string   "hour"
    t.string   "location"
    t.text     "contents",   :limit => 16777215, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "documents", :force => true do |t|
    t.string  "title"
    t.string  "original_filename"
    t.integer "case_id"
    t.integer "storage_id"
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.string   "event_subtype"
    t.string   "detail_s1"
    t.integer  "detail_i1"
    t.integer  "started_at"
    t.integer  "finished_at"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "detail_s2"
  end

  create_table "file_assets", :force => true do |t|
    t.integer "parent_id"
    t.string  "parent_type"
    t.integer "user_id"
    t.string  "role"
    t.string  "format"
    t.string  "content_type"
    t.integer "filesize"
    t.string  "path"
  end

  add_index "file_assets", ["parent_id"], :name => "index_file_assets_on_parent_id"

  create_table "folders", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "footers", :force => true do |t|
    t.integer  "case_id"
    t.boolean  "all_pages",     :default => false,  :null => false
    t.string   "link"
    t.string   "alignment",     :default => "left", :null => false
    t.string   "bgcolor"
    t.boolean  "border",        :default => false,  :null => false
    t.string   "font_face"
    t.integer  "font_size"
    t.string   "font_color"
    t.boolean  "divider_above", :default => false,  :null => false
    t.integer  "divider_size"
    t.integer  "divider_width"
    t.string   "divider_color"
    t.text     "contents"
    t.string   "text_align",    :default => "left", :null => false
    t.boolean  "divider_below", :default => false,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "html_details", :force => true do |t|
    t.integer  "block_id",                       :null => false
    t.text     "contents",   :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letterheads", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.boolean  "all_pages",      :default => false,  :null => false
    t.string   "link"
    t.string   "alignment",      :default => "left", :null => false
    t.string   "bgcolor"
    t.boolean  "border",         :default => false,  :null => false
    t.string   "font_face"
    t.integer  "font_size"
    t.string   "font_color"
    t.boolean  "divider_above",  :default => false,  :null => false
    t.integer  "divider_size"
    t.integer  "divider_width"
    t.string   "divider_color"
    t.text     "contents"
    t.string   "logo_alignment", :default => "left", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text_align",     :default => "left", :null => false
  end

  create_table "logos", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "letterhead_id"
    t.string   "path",          :null => false
    t.string   "content_type",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
    t.integer  "storage_id"
  end

  add_index "logos", ["storage_id"], :name => "index_logos_on_storage_id"

  create_table "notes", :force => true do |t|
    t.integer  "case_id"
    t.text     "contents"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notes", ["case_id"], :name => "index_notes_on_case_id"

  create_table "page_breaks", :force => true do |t|
    t.integer  "block_id",                       :null => false
    t.boolean  "with_header", :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "pictures", :force => true do |t|
    t.integer  "block_id",          :null => false
    t.string   "title"
    t.string   "path",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_filename"
    t.string   "content_type"
    t.string   "unique_code"
    t.string   "alignment"
    t.integer  "width"
    t.integer  "height"
    t.integer  "storage_id"
    t.integer  "scaling"
  end

  add_index "pictures", ["storage_id"], :name => "index_pictures_on_storage_id"

  create_table "purchases", :force => true do |t|
    t.string   "label"
    t.integer  "user_id"
    t.decimal  "amount",          :precision => 10, :scale => 0
    t.datetime "used_at"
    t.integer  "used_by_case_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "purchases", ["used_by_case_id"], :name => "index_purchases_on_used_by_case_id"
  add_index "purchases", ["user_id"], :name => "index_purchases_on_user_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "sent_emails", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.string   "label",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "settings", :force => true do |t|
    t.integer "non_cc_trial", :default => 0, :null => false
  end

  create_table "storages", :force => true do |t|
    t.string  "mount_point"
    t.integer "size"
  end

  create_table "subscription_plans", :force => true do |t|
    t.string   "chargify_handle"
    t.integer  "cases_max"
    t.decimal  "extra_case_price", :precision => 10, :scale => 0
    t.integer  "clients_max"
    t.integer  "storage_max_mb"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "chargify_slug"
    t.decimal  "price",            :precision => 10, :scale => 0
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "chargify_id"
    t.string   "product_handle"
    t.integer  "user_id"
    t.integer  "subscription_plan_id"
    t.datetime "period_ends_at"
    t.datetime "next_assessment_at"
    t.string   "status"
    t.integer  "cases_max"
    t.integer  "cases_count"
    t.decimal  "extra_case_price",     :precision => 10, :scale => 0
    t.integer  "extra_cases_count"
    t.integer  "clients_max"
    t.integer  "clients_count"
    t.integer  "storage_max_mb"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "subscriptions", ["subscription_plan_id"], :name => "index_subscriptions_on_subscription_plan_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "text_snippets", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body",       :limit => 16777215
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "text_snippets", ["user_id"], :name => "index_text_snippets_on_user_id"

  create_table "user_addresses", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_clients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_clients", ["user_id", "client_id"], :name => "index_user_clients_on_user_id_and_client_id", :unique => true

  create_table "user_employees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_employees", ["user_id", "employee_id"], :name => "index_user_employees_on_user_id_and_employee_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "company_name"
    t.boolean  "admin",                                 :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "block_id",          :null => false
    t.string   "title"
    t.string   "path",              :null => false
    t.string   "original_filename"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
    t.string   "thumbnail"
    t.string   "type"
    t.string   "filename"
    t.string   "thumbnail_pos"
    t.string   "unique_code"
    t.float    "fps"
    t.integer  "duration"
    t.string   "alignment"
    t.integer  "storage_id"
    t.integer  "scaling"
  end

  add_index "videos", ["storage_id"], :name => "index_videos_on_storage_id"

  create_table "viewers", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "viewer_id"
  end

  create_table "witness_statements", :force => true do |t|
    t.integer  "block_id"
    t.string   "day"
    t.string   "hour"
    t.string   "name"
    t.string   "address"
    t.string   "city_state_zip"
    t.text     "contents",       :limit => 16777215
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
