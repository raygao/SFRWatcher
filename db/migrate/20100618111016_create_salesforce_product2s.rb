class CreateSalesforceProduct2s < ActiveRecord::Migration
  def self.up
    create_table :product2s do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :product2s
  end
end
