require 'test_helper'

class Salesforce::LeadTest < ActiveSupport::TestCase
  def test_should_return_leads
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    leads = Array.new
    leads = Salesforce::Lead.find(:all).count
    assert_not_nil leads
  end

end
