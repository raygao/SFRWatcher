class CreateLocalSalesforceObjectTypes < ActiveRecord::Migration
  def self.up
    create_table :salesforce_object_types do |t|
      t.string   :object_type
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :salesforce_objects, :salesforce_object_type_id, :integer

    add_index :salesforce_objects, [:salesforce_object_type_id]

    SalesforceObjectType.create :object_type => "Account"
    SalesforceObjectType.create :object_type => "Asset"
    SalesforceObjectType.create :object_type => "Campaign"
    SalesforceObjectType.create :object_type => "Contact"
    SalesforceObjectType.create :object_type => "Contract"
    SalesforceObjectType.create :object_type => "Group"
    SalesforceObjectType.create :object_type => "Lead"
    SalesforceObjectType.create :object_type => "Opportunity"
    SalesforceObjectType.create :object_type => "Organization"
    SalesforceObjectType.create :object_type => "Product2"
    SalesforceObjectType.create :object_type => "Solution"
    SalesforceObjectType.create :object_type => "User"


  end

  def self.down
    remove_column :salesforce_objects, :salesforce_object_type_id

    drop_table :salesforce_object_types

    remove_index :salesforce_objects, :name => :index_salesforce_objects_on_salesforce_object_type_id rescue ActiveRecord::StatementInvalid
  end
end
