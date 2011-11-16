# Be sure to restart your server when you modify this file.

# Mvp::Application.config.session_store :cookie_store, :key => '_mvp_session'
Mvp::Application.config.session_store :active_record_store, :key => '_mvp_session'
Mvp::Application.config.action_dispatch.session = {
  :key    => '_mvp_session',
  :secret => '0x0dkfj3927dkc7djdh36rkckdfzsgkc7djdh36rkckdfzsg'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Mvp::Application.config.session_store :active_record_store
