class CreateLocalSalesforceObject < ActiveRecord::Migration
  def self.up
    create_table :salesforce_objects do |t|
      t.string   :object_id
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :salesforce_objects
  end
end
