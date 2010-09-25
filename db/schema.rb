# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100827231900) do

  create_table "account_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asset_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "case_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chatter_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chatter_sessions", :force => true do |t|
    t.string   "link_url"
    t.string   "link_title"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "chatter_sessions", ["owner_id"], :name => "index_chatter_sessions_on_owner_id"

  create_table "contact_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contracts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_subscriptions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_tracked_changes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule_id"
    t.integer  "owner_id"
  end

  add_index "filters", ["owner_id"], :name => "index_filters_on_owner_id"
  add_index "filters", ["rule_id"], :name => "index_filters_on_rule_id"

  create_table "hobo_users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
    t.string   "salesforce_username"
    t.string   "salesforce_password"
    t.string   "salesforce_secret_token"
    t.boolean  "chatter_load_attachment",                 :default => true
  end

  add_index "hobo_users", ["state"], :name => "index_hobo_users_on_state"

  create_table "lead_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opportunities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opportunity_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product2_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product2s", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  add_index "rules", ["owner_id"], :name => "index_rules_on_owner_id"

  create_table "salesforce_object_types", :force => true do |t|
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salesforce_objects", :force => true do |t|
    t.string   "object_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "salesforce_object_type_id"
  end

  add_index "salesforce_objects", ["salesforce_object_type_id"], :name => "index_salesforce_objects_on_salesforce_object_type_id"

  create_table "salesforce_sf_bases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "solution_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solutions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule_id"
    t.integer  "owner_id"
  end

  add_index "tasks", ["owner_id"], :name => "index_tasks_on_owner_id"
  add_index "tasks", ["rule_id"], :name => "index_tasks_on_rule_id"

  create_table "user_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profile_feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "filter_id"
    t.integer  "owner_id"
  end

  add_index "words", ["filter_id"], :name => "index_words_on_filter_id"
  add_index "words", ["owner_id"], :name => "index_words_on_owner_id"

end
