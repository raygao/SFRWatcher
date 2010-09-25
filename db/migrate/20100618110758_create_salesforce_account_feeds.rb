class CreateSalesforceAccountFeeds < ActiveRecord::Migration
  def self.up
    create_table :account_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :account_feeds
  end
end
