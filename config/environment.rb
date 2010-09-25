################################################################################
# Project SFRWatcher: A Salesforce Chatter Externalization Tool                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
# Demo app running on http://parl8-vo.us:3000/                                 #
################################################################################

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Loading dependency libraries.
require RAILS_ROOT + '/lib/parl8_vous/parl8_vous_lib_loader.rb'

#require RAILS_ROOT + '/lib/asf/activerecord-activesalesforce-adapter.rb'

Rails::Initializer.run do |config|
  config.gem 'hobo'

  config.gem "althor880-activerecord-activesalesforce-adapter",
    :source => "http://rubygems.org", :lib => "activerecord-activesalesforce-adapter"

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de


  # logging level
  #config.log_level = 4
  # Using DB to store session for clustering reason
  config.action_controller.session_store = :active_record_store

  config = YAML.load_file(RAILS_ROOT + "/config/config.yml")
  MAX_SESSION_PERIOD = config['MAX_SESSION_PERIOD']
  QUERY_RESULT_LIMIT = config['QUERY_RESULT_LIMIT']
  DOWNLOAD_ICON = config['DOWNLOAD_ICON']
end

# Date format, see http://www.practicalecommerce.com/blogs/post/96-Custom-Date-Output-Using-Rails
# ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:standard => "%B %d, %Y")
# ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:standard => "%B %d, %Y")
# :fmt_date is used in the project, to make more friend Date display, in
# listings/show_pending.fbml.erb, admin/expire_stale_listings.fbml.erb
# home/index.fbml.erb, listings/inex.fbml.erb, and listings/show.fbml.erb
Time::DATE_FORMATS[:fmt_date] = "%A, %B %d, %Y"

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "Address of the Mail Server",
  :port           => 587,
  :domain         => "Mail domain",
  :user_name      => "Username on the Mail Server",
  :authentication => :plain,
  :password       => "Password on the Mail Server",
  :enable_starttls_auto => true,
}
