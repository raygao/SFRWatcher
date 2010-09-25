class CreateSalesforceEntitySubscriptions < ActiveRecord::Migration
  def self.up
    create_table :entity_subscriptions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :entity_subscriptions
  end
end
