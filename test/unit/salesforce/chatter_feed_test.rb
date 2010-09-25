require 'test_helper'
#require RAILS_ROOT + '/lib/asf/activerecord-activesalesforce-adapter'

class Salesforce::ChatterFeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # Cannot query 'FeedPost' directly
  test "the truth" do
    assert true
  end

  def test_get_chatter_feed_without_content_file
    user = Salesforce::User.first
    chatter_feed_finder = Salesforce::ChatterFeed.new
    chatter_feed_without_attachment = chatter_feed_finder.get_all_chatter_feeds_without_attachments('001A0000009ZtSkIAK', 'Account', user.connection.binding, 'test-session-id')
    assert_not_nil chatter_feed_without_attachment
  end

  def test_get_chatter_feed_with_content_file
    user = Salesforce::User.first
    chatter_feed_finder = Salesforce::ChatterFeed.new
    chatter_feed_with_attachment = chatter_feed_finder.get_all_chatter_feeds_with_attachments('001A0000009ZtSkIAK', 'Account', user.connection.binding, 'test-session-id')
    assert_not_nil chatter_feed_with_attachment
  end

end
