class CreateSalesforceNewsFeeds < ActiveRecord::Migration
  def self.up
    create_table :news_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :news_feeds
  end
end
