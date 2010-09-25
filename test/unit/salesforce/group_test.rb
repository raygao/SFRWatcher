require File.dirname(__FILE__) + '/../../test_helper'

class Salesforce::GroupTest < ActiveSupport::TestCase

  def test_should_return_groups
    groups = Array.new
    groups = Salesforce::Group.find(:all).count
    assert_not_nil groups
  end

  def test_should_return_groups
    match_string = "@hi.com"
    query_conditions = ["id = :id and email like :search", {:search => "%" +  match_string + "%", :id => '00GA0000000sNNwMAM'}]
    # for example
    # query_conditions = ["id = :id and email like :search", {:search => "%" +  match_string + "%", :id => '00GA0000000sNNwMAM'}]
    # results = Salesforce::Group.find(:all, :conditions => query_conditions)
    
    results = salesforce_object_find_by_type_and_conditions("Group", query_conditions)
    assert_not_nil results
  end
end


