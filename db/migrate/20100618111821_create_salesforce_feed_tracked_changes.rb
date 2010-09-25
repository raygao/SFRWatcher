class CreateSalesforceFeedTrackedChanges < ActiveRecord::Migration
  def self.up
    create_table :feed_tracked_changes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_tracked_changes
  end
end
