class CreateSalesforceContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contracts
  end
end
