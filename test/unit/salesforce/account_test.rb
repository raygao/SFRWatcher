require 'test_helper'
require RAILS_ROOT + '/lib/asf/activerecord-activesalesforce-adapter'

class Salesforce::AccountTest < ActiveSupport::TestCase
  # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
  def test_find_accounts_with_rforce
    ##Test case with RFace
    @binding = RForce::Binding.new 'https://login.salesforce.com/services/Soap/u/19.0'

    @binding.login USERID, (PASSWORD + SECURITY_TOKEN)
    answer = @binding.search :searchString => "find {Arizona} in name fields returning account(id, phone)"
    assert_not_nil answer
  end

  def test_find_accounts_with_rforce_by_name_and_description
    ##Test case with RFace
    @binding = RForce::Binding.new 'https://login.salesforce.com/services/Soap/u/19.0'

    @binding.login USERID, (PASSWORD + SECURITY_TOKEN)
    name = 'company'
    object_type = 'Account'

    @results = @binding.search :searchString => "find {#{name}} in all fields returning account(id, phone)"
    assert_not_nil @results
  end

  def test_should_return_account
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    #Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first   

    accounts = Array.new
    accounts = user.accounts

    #puts "The user {" +  user.first_name + " " + user.last_name + "} has " + user.accounts.size.to_s + " accounts."
    assert_not_nil accounts
  end

end

=begin
RFace example
#  Example:
#
#    binding = RForce::Binding.new 'https://www.salesforce.com/services/Soap/u/10.0'
#    binding.login 'username', 'password'
#    answer = binding.search(
#      :searchString =>
#        'find {Some Account Name} in name fields returning account(id)')
#    account_id = answer.searchResponse.result.searchRecords.record.Id
#
#    opportunity = {
#      :accountId => account_id,
#      :amount => "10.00",
#      :name => "New sale",
#      :closeDate => "2005-09-01",
#      :stageName => "Closed Won"
#    }
#
#    binding.create 'sObject {"xsi:type" => "Opportunity"}' => opportunity
=end