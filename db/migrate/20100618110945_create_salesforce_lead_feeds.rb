class CreateSalesforceLeadFeeds < ActiveRecord::Migration
  def self.up
    create_table :lead_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :lead_feeds
  end
end
