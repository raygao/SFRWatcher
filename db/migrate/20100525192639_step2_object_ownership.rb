class Step2ObjectOwnership < ActiveRecord::Migration
  def self.up
    add_column :rules, :owner_id, :integer

    add_column :tasks, :owner_id, :integer

    add_column :filters, :owner_id, :integer

    add_index :rules, [:owner_id]

    add_index :tasks, [:owner_id]

    add_index :filters, [:owner_id]
  end

  def self.down
    remove_column :rules, :owner_id

    remove_column :tasks, :owner_id

    remove_column :filters, :owner_id

    remove_index :rules, :name => :index_rules_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :tasks, :name => :index_tasks_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :filters, :name => :index_filters_on_owner_id rescue ActiveRecord::StatementInvalid
  end
end
