class CreateSalesforceContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
