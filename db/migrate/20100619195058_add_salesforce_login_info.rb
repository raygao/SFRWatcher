class AddSalesforceLoginInfo < ActiveRecord::Migration
  def self.up
    add_column :hobo_users, :salesforce_username, :string
    add_column :hobo_users, :salesforce_password, :string
    add_column :hobo_users, :salesforce_secret_token, :string
    add_column :hobo_users, :chatter_load_attachment, :boolean, :default => true
  end

  def self.down
    remove_column :hobo_users, :salesforce_username
    remove_column :hobo_users, :salesforce_password
    remove_column :hobo_users, :salesforce_secret_token
    remove_column :hobo_users, :chatter_load_attachment
  end
end
