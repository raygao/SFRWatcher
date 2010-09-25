class CreateSalesforceUserProfileFeeds < ActiveRecord::Migration
  def self.up
    create_table :user_profile_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_profile_feeds
  end
end
