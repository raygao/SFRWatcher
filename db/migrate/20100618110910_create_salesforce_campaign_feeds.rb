class CreateSalesforceCampaignFeeds < ActiveRecord::Migration
  def self.up
    create_table :campaign_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :campaign_feeds
  end
end
