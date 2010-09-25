class CreateSalesforceFeedComments < ActiveRecord::Migration
  def self.up
    create_table :feed_comments do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_comments
  end
end
