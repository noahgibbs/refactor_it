# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_refactor_session',
  :secret      => '83caa6df3076fc1dbe9ee28be368c7091b7f2262378a32e6339b0d77123fbd9769fc04c5f8bf5f6852b2d9c5f3fc2b0ee807936eb7c5f250ea26046bf047922a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
