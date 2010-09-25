class CreateSalesforceOpportunities < ActiveRecord::Migration
  def self.up
    create_table :opportunities do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :opportunities
  end
end
