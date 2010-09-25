class UserActivtion < ActiveRecord::Migration
  def self.up
    #change_column :hobo_users, :state, :string, :limit => 255, :default => "inactive"
  end

  def self.down
    #change_column :hobo_users, :state, :string, :default => "active"
  end
end
