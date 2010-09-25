class Salesforce::ContactFeed < Salesforce::SfBase
  set_table_name 'contact_feeds'
  # Below is not necessary. Auto built by ActiveSalesforce-Adapter gem, albeit a little slow.
  #belongs_to :parent, :class_name => "Salesforce::Contact"
end
