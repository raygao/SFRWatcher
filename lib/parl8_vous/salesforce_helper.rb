=begin
parl8_vous helper method
Copyright 2010 Raymond Gao

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

# SalesObject KeyPrefix 3 digits code
# ID   Prefix	Entity Type
# (Following has associated ChatterFeed {object}Feed
#   001	Account
#   02i Asset
#   500 Case
#   701	Campaign
#   003	Contact
#   800 Contract
#   00G Group
#   00Q	Lead
#   006	Opportunity
#   00D	Organization
#   01t Product2
#   501 Solution
#   00T Task
#   005	User
#
#   (Special Feed class, with no associated SF object)
#   0D5 NewsFeed is special, It does not have SF Object
#
#   (Other Chatter Object without Feed)
#   00V	Campaign Member
#   00e	Profile
#   00N	Custom Field Definition
#
# (FeedItem vs. FeedPost)
#  0D5  FeedItem (post by everyone)
#  0F7  FeedPost (post made by this user)
#
# See: http://eng.genius.com/blog/2009/05/17/salesforcecom-api-gotchas-2/
def determine_sf_object_type(id)
  String oid = id[0,3]
  case oid
  when '001'
    return 'Account'
  when '02i'
    return 'Asset'
  when '500'
    return 'Case'
  when '701'
    return 'Campaign'
  when '003'
    return 'Contact'
  when '800'
    return 'Contract'
  when '00G'
    return 'Group'
  when '00Q'
    return 'Lead'
  when '006'
    return 'Opportunity'
  when '00D'
    return 'Organization'
  when '01t'
    return 'Product2'
  when '501'
    return 'Solution'
  when '00T'
    return 'Task'
  when '005'
    return 'User'
 # below are other Salesforce object without chatter {object}Feed
  when '00V'
    return 'Campaign Member'
  when '00E'
    return 'Profile'
  when '00N'
    return 'Custom_Field_Definition'
  #distinction between FeedItem and FeedPost
  when '0D5'
    return 'FeedItem'
  when '0F7'
    return 'FeedPost'
  else
    return 'Unknown'
  end
end


# Finders the appropriate Salesforce Object based on Object. No more guess work.
# nil means that the {oid} is not supported by this method, e.g. not suitable.
def salesforce_object_find_by_id (oid)
  query_conditions = Hash.new
  query_conditions[:id] = oid

  otype = determine_sf_object_type(oid)
  if otype != 'Unknown'
    sf_object = salesforce_object_find_all(otype, query_conditions).first
  else
    sf_object = nil
  end

  return sf_object
end


# Finders the appropriate Salesforce Object based on Object Type and description
# nil means that the {oid} is not supported by this method, e.g. not suitable.
def salesforce_object_find_by_type_and_conditions (otype, query_conditions)
  # for example
  #Salesforce::Group.find(:all, :conditions => ["email like :search", {:search => '%.com'}])

  sf_objects = salesforce_object_find_all(otype, query_conditions)

  return sf_objects
end

#TODO to combine the two into one function.
# Finders the appropriate Salesforce Object based on the Object Type
# returning nil means that the {oid} is not supported by this method, e.g. not suitable.
def salesforce_object_find_all(otype, query_conditions = nil)
  case otype
  when 'Account'
    sf_object = Salesforce::Account.find(:all, :conditions => query_conditions)
  when 'Asset'
    sf_object = Salesforce::Asset.find(:all, :conditions => query_conditions)
  when 'Case'
    sf_object = Salesforce::Case.find(:all, :conditions => query_conditions)
  when 'Campaign'
    sf_object = Salesforce::Campaign.find(:all, :conditions => query_conditions)
  when 'Contact'
    sf_object = Salesforce::Contact.find(:all, :conditions => query_conditions)
  when 'Contract'
    sf_object = Salesforce::Contract.find(:all, :conditions => query_conditions)
  when 'Group'
    sf_object = Salesforce::Group.find(:all, :conditions => query_conditions)
  when 'Lead'
    sf_object = Salesforce::Lead.find(:all, :conditions => query_conditions)
  when 'Opportunity'
    sf_object = Salesforce::Opportunity.find(:all, :conditions => query_conditions)
  when 'Organization'
    sf_object = Salesforce::Organization.find(:all, :conditions => query_conditions)
  when 'Product2'
    sf_object = Salesforce::Product2.find(:all, :conditions => query_conditions)
  when 'Solution'
    sf_object = Salesforce::Solution.find(:all, :conditions => query_conditions)
  when 'User'
    sf_object = Salesforce::User.find(:all, :conditions => query_conditions)

  else
    sf_object = nil
  end

  return sf_object
end




#TODO to combine the two into one function.
# Create a blank Salesforce Object based on the object type.
def salesforce_object_create(otype)
  case otype
  when 'Account'
    sf_object = Salesforce::Account.new()
  when 'Asset'
    sf_object = Salesforce::Asset.new()
  when 'Case'
    sf_object = Salesforce::Case.new()
  when 'Campaign'
    sf_object = Salesforce::Campaign.new()
  when 'Contact'
    sf_object = Salesforce::Contact.new()
  when 'Contract'
    sf_object = Salesforce::Contract.new()
  when 'Group'
    sf_object = Salesforce::Group.new()
  when 'Lead'
    sf_object = Salesforce::Lead.new()
  when 'Opportunity'
    sf_object = Salesforce::Opportunity.new()
  when 'Organization'
    sf_object = Salesforce::Organization.new()
  when 'Product2'
    sf_object = Salesforce::Product2.new()
  when 'Solution'
    sf_object = Salesforce::Solution.new()
  when 'User'
    sf_object = Salesforce::User.new()

  else
    sf_object = nil
  end

  return sf_object
end