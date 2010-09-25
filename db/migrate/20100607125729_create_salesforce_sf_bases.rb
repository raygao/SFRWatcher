class CreateSalesforceSfBases < ActiveRecord::Migration
  def self.up
    create_table :salesforce_sf_bases do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :salesforce_sf_bases
  end
end
