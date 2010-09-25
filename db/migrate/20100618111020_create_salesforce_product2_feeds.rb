class CreateSalesforceProduct2Feeds < ActiveRecord::Migration
  def self.up
    create_table :product2_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :product2_feeds
  end
end
