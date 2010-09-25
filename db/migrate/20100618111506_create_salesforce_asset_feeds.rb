class CreateSalesforceAssetFeeds < ActiveRecord::Migration
  def self.up
    create_table :asset_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :asset_feeds
  end
end
