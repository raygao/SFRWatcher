class CreateSalesforceCaseFeeds < ActiveRecord::Migration
  def self.up
    create_table :case_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :case_feeds
  end
end
