class CreateSalesforceContactFeeds < ActiveRecord::Migration
  def self.up
    create_table :contact_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_feeds
  end
end
