class CreateSalesforceFeedPosts < ActiveRecord::Migration
  def self.up
    create_table :feed_posts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_posts
  end
end
