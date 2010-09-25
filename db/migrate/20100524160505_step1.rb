class Step1 < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.string   :name
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :tasks do |t|
      t.string   :name
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :rule_id
    end
    add_index :tasks, [:rule_id]

    create_table :filters do |t|
      t.string   :name
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :rule_id
    end
    add_index :filters, [:rule_id]
  end

  def self.down
    drop_table :rules
    drop_table :tasks
    drop_table :filters
  end
end
