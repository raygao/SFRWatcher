class CreateSalesforceSolutionFeeds < ActiveRecord::Migration
  def self.up
    create_table :solution_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :solution_feeds
  end
end
