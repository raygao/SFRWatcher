class AssociateChatterSessionToHoboUser < ActiveRecord::Migration
  def self.up
    add_column :chatter_sessions, :owner_id, :integer

    add_index :chatter_sessions, [:owner_id]
  end

  def self.down
    remove_column :chatter_sessions, :owner_id

    remove_index :chatter_sessions, :name => :index_chatter_sessions_on_owner_id rescue ActiveRecord::StatementInvalid
  end
end
