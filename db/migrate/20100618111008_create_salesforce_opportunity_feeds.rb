class CreateSalesforceOpportunityFeeds < ActiveRecord::Migration
  def self.up
    create_table :opportunity_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :opportunity_feeds
  end
end
