class AddWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string   :name
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :filter_id
    end
    add_index :words, [:filter_id]
  end

  def self.down
    drop_table :words
  end
end
