require File.dirname(__FILE__) + '/../test_helper'

class RuleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_return_rule
    rule = Rule.find(:first)

    rules = Array.new
    rules = Rule.find(:all).count
    assert_not_nil rules
  end

end
