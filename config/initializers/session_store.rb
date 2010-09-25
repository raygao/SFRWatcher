# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_watcher_session',
  :secret      => '918edf68b6c53f00a3b328e2182cd1197b41b89a5a8d6d8141a53f6747f158d2ae427ac6caa43e4bdfbacde7eeaf60cf74190d4e4c369cdd8f04655bb25353d9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
