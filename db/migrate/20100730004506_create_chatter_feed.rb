class CreateChatterFeed < ActiveRecord::Migration
  def self.up
    create_table :chatter_feeds do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :chatter_feeds
  end
end
