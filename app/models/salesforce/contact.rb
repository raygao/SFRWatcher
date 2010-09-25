class Salesforce::Contact < Salesforce::SfBase
  #table name must match the Salesforce, or it does not work. This is a quirk of the ActiveSalesforce
  set_table_name 'contacts'
  #table name must match the Salesforce, or it does not work. This is a quirk of the ActiveSalesforce'

  # Below is not necessary. Auto built by ActiveSalesforce-Adapter gem, albeit a little slow.
  #belongs_to :owner, :class_name => "Salesforce::User"
  #has_many :contact_feeds, :class_name => 'Salesforce::ContactFeed', :foreign_key => 'parent_id'
end
