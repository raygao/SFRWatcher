class AddOwnershipToWord < ActiveRecord::Migration
  def self.up
    add_column :words, :owner_id, :integer

    add_index :words, [:owner_id]
  end

  def self.down
    remove_column :words, :owner_id

    remove_index :words, :name => :index_words_on_owner_id rescue ActiveRecord::StatementInvalid
  end
end
