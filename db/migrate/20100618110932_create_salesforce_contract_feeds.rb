class CreateSalesforceContractFeeds < ActiveRecord::Migration
  def self.up
    create_table :contract_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contract_feeds
  end
end
