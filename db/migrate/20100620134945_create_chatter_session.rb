class CreateChatterSession < ActiveRecord::Migration
  def self.up
    create_table :chatter_sessions do |t|
      t.string   :link_url
      t.string   :link_title
#      t.string   :post_type
      t.string   :session
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :chatter_sessions
  end
end
