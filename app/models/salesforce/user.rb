class Salesforce::User < Salesforce::SfBase
  has_many :contacts, :class_name => "Salesforce::Contact", :foreign_key => 'owner_id'
  has_many :accounts, :class_name => 'Salesforce::Account', :foreign_key => 'owner_id'
  set_table_name 'users'
  #table name must match the Salesforce, or it does not work. This is a quirk of the ActiveSalesforce
  #TODO move the Salesforce::User into a different table name, it should not be the same as the 'Users' of the Hobo.
  #this causes inconvience with 'script/generate hobo_migration' command
end
